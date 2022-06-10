<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of locations of those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:origPlace[@ref]|//tei:repository[@ref]" group-by="@ref">
        <xsl:variable name="id">
          <xsl:choose>
            <xsl:when test="contains(@ref, '#')">
              <xsl:value-of select="substring-after(@ref, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@ref"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="locationsAL" select="'../../content/xml/authority/locations.xml'"/>
        <xsl:variable name="idno" select="document($locationsAL)//tei:place[@xml:id=$id]"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:choose>
              <xsl:when test="doc-available($locationsAL) = fn:true() and $idno">
                <xsl:value-of select="normalize-space(translate(translate(translate($idno//tei:placeName[@xml:lang='en'], '/', '／'), '_', ' '), '(?)', ''))" /> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$id" />
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_id">
            <xsl:value-of select="translate($id, ' ', '_')"/>
          </field>
          <field name="index_item_type">
            <xsl:choose>
              <xsl:when test="self::tei:origPlace"><xsl:text>Monument</xsl:text></xsl:when>
              <xsl:when test="self::tei:repository"><xsl:text>Repository</xsl:text></xsl:when>
            </xsl:choose>
          </field>
          
          <!--<xsl:if test="doc-available($locationsAL) = fn:true() and $idno">-->
          <field name="index_item_alt_name">
            <xsl:value-of select="$idno//tei:placeName[@xml:lang='el']"/>
          </field>
          <field name="index_district">
            <xsl:choose>
              <xsl:when test="contains($idno//tei:placeName[@type='district'][1]/@ref, '#')">
                <xsl:value-of select="substring-after($idno//tei:placeName[@type='district'][1]/@ref, '#')"/> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$idno//tei:placeName[@type='district']"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_diocese">
            <xsl:choose>
              <xsl:when test="contains($idno//tei:placeName[@type='diocese'][1]/@ref, '#')">
                <xsl:value-of select="substring-after($idno//tei:placeName[@type='diocese'][1]/@ref, '#')"/> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$idno//tei:placeName[@type='diocese']"/>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_coordinates">
            <xsl:value-of select="$idno//tei:location/tei:geo"/>
          </field>
            <field name="index_construction">
              <xsl:value-of select="$idno//tei:desc[@type='construction']"/>
            </field>
            <field name="index_function">
              <xsl:value-of select="$idno//tei:desc[@type='function']"/>
            </field>
            <field name="index_context">
              <xsl:value-of select="$idno//tei:desc[@type='context']"/>
            </field>
            <field name="index_architectural_context">
              <xsl:value-of select="$idno//tei:desc[@type='architectural']"/>
          </field>
            <field name="index_mural">
              <xsl:value-of select="$idno//tei:desc[@type='mural']"/>
          </field>
            <field name="index_conservation">
              <xsl:value-of select="$idno//tei:desc[@type='conservation']"/>
          </field>
            <field name="index_donors">
              <xsl:value-of select="$idno//tei:desc[@type='donors']"/>
            </field>
            <field name="index_painter">
              <xsl:value-of select="$idno//tei:desc[@type='painter']"/>
            </field>
            <field name="index_graffiti">
              <xsl:value-of select="$idno//tei:desc[@type='graffiti']"/> <!-- <ref target="URL">...</ref> -->
            </field>
            <xsl:for-each select="$idno//tei:idno[@type]">
                <field name="index_external_resource">
                  <xsl:value-of select="@type"/>: <xsl:value-of select="."/>
                </field>
              </xsl:for-each>
              <xsl:choose>
                <xsl:when test="$idno//tei:listBibl[@type='inscriptions']/tei:bibl[@ana='unpublished']">
                  <field name="index_inscriptions_bibl">
                    <xsl:text>unpublished</xsl:text>
                  </field>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$idno//tei:listBibl[@type='inscriptions']/tei:bibl/tei:ptr">
                    <field name="index_inscriptions_bibl">
                    <xsl:value-of select="substring-after(@target, '#')"/>
                    <xsl:if test="following-sibling::tei:citedRange">
                    <xsl:text>, </xsl:text>
                      <xsl:value-of select="following-sibling::tei:citedRange"/>
                    </xsl:if>
                    </field>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            
            <xsl:choose>
              <xsl:when test="$idno//tei:listBibl[@type='monument']/tei:bibl[@ana='unpublished']">
                <field name="index_monument_bibl">
                  <xsl:text>unpublished</xsl:text>
                </field>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$idno//tei:listBibl[@type='monument']/tei:bibl/tei:ptr">
                  <field name="index_monument_bibl">
                    <xsl:value-of select="substring-after(@target, '#')"/>
                    <xsl:if test="following-sibling::tei:citedRange">
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="following-sibling::tei:citedRange"/>
                    </xsl:if>
                  </field>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          <!--</xsl:if>-->
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:origPlace|tei:repository">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
