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
                <!--<xsl:value-of select="$idno//tei:place" />--> <!-- to be displayed here all data about monuments in a  structured way -->
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
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:origPlace|tei:repository">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
