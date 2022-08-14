<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of persons in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each select="//tei:persName[not(@type='divine' or @type='sacred')][ancestor::tei:div/@type='edition']">
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
        <xsl:variable name="personsAL" select="'../../content/xml/authority/persons.xml'"/>
        <xsl:variable name="idno" select="document($personsAL)//tei:person[@xml:id=$id]"/>
        <xsl:variable name="xmlid" select="@xml:id"/>
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="translate(string-join(descendant::tei:name[@type='forename']/@nymRef, ' '), '#', '')" />
            <xsl:if test="ancestor::tei:div[@type='edition']//tei:persName[@sameAs=concat('#',$xmlid)]">
              <xsl:for-each select="ancestor::tei:div[@type='edition']//tei:persName[@sameAs=concat('#',$xmlid)]/descendant::tei:name[@type='forename']/@nymRef">
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(., '#', '')" />
              </xsl:for-each>
            </xsl:if>
          </field>
          <field name="index_surname">
            <xsl:value-of select="translate(string-join(descendant::tei:name[@type='surname']/@nymRef, ' '), '#', '')"/>
            <xsl:if test="ancestor::tei:div[@type='edition']//tei:persName[@sameAs=concat('#',$xmlid)]">
              <xsl:for-each select="ancestor::tei:div[@type='edition']//tei:persName[@sameAs=concat('#',$xmlid)]/descendant::tei:name[@type='surname']/@nymRef">
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(., '#', '')" />
              </xsl:for-each>
            </xsl:if>
          </field>
          <field name="index_item_type">
            <!--To pick data from AL:-->
            <!--<xsl:if test="doc-available($personsAL) = fn:true() and $idno">
              <xsl:choose>
                <xsl:when test="$idno/ancestor::tei:list[@type='...']">
                  <xsl:text>...</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:if>-->
            <xsl:value-of select="'-'"/>
            <!-- 4 categories:
            - Rulers / Officials / Ecclesiastical officials / monastics: if <rs type="office">?
            - Founders / Donors: if association is founder/donor'?
            - Painters: if association or occupation is 'painter'?
            - Other people: remaining people
            [Or from AL, or from @type='ruler/official/founder/donor/painter/attested'?]
            -->    
          </field>
          
          <field name="index_honorific">
            <xsl:variable name="honorifics" select="descendant::tei:rs[@type='honorific']|ancestor::tei:rs[@type='honorific']|ancestor::tei:div[@type='edition']//tei:rs[@type='honorific'][@sameAs=concat('#',$xmlid)]"/>
            <xsl:for-each select="$honorifics">
                <xsl:choose>
                  <xsl:when test="@ref">
                    <xsl:value-of select="@ref"/>
                  </xsl:when>
                  <xsl:when test="@key">
                    <xsl:value-of select="@key"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              <xsl:if test="position()!=last()">; </xsl:if>
            </xsl:for-each>
          </field>
          
          <field name="index_secular_office">
            <xsl:variable name="offices" select="descendant::tei:rs[@type='office']|ancestor::tei:rs[@type='office']|ancestor::tei:div[@type='edition']//tei:rs[@type='office'][@sameAs=concat('#',$xmlid)]"/>
            <xsl:variable name="rs-id">
              <xsl:choose>
                <xsl:when test="contains($offices/@ref, '#')">
                  <xsl:value-of select="substring-after($offices/@ref, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$offices/@ref"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="officesAL" select="'../../content/xml/authority/offices.xml'"/>
            <xsl:variable name="rs-idno" select="document($officesAL)//tei:item[@xml:id=$rs-id]"/>
            <xsl:for-each select="$offices">
              <xsl:if test="doc-available($officesAL) = fn:true() and $rs-idno/ancestor::tei:list[@type='secular_offices']">
                <xsl:value-of select="$rs-idno//tei:term[1]" />
              </xsl:if>
              <xsl:if test="position()!=last()">; </xsl:if>
            </xsl:for-each>
          </field>
          
          <field name="index_dignity">
            <xsl:variable name="dignities" select="descendant::tei:rs[@type='dignity']|ancestor::tei:rs[@type='dignity']|ancestor::tei:div[@type='edition']//tei:rs[@type='dignity'][@sameAs=concat('#',$xmlid)]"/>
            <xsl:variable name="rs-id">
              <xsl:choose>
                <xsl:when test="contains($dignities/@ref, '#')">
                  <xsl:value-of select="substring-after($dignities/@ref, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$dignities/@ref"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="officesAL" select="'../../content/xml/authority/offices.xml'"/>
            <xsl:variable name="rs-idno" select="document($officesAL)//tei:item[@xml:id=$rs-id]"/>
            <xsl:for-each select="$dignities">
              <xsl:if test="doc-available($officesAL) = fn:true() and $rs-idno/ancestor::tei:list[@type='secular_dignities']">
                <xsl:value-of select="$rs-idno//tei:term[1]" />
              </xsl:if>
              <xsl:if test="position()!=last()">; </xsl:if>
            </xsl:for-each>
          </field>
          
          <field name="index_ecclesiastical_office">
            <xsl:variable name="offices" select="descendant::tei:rs[@type='office']|ancestor::tei:rs[@type='office']|ancestor::tei:div[@type='edition']//tei:rs[@type='office'][@sameAs=concat('#',$xmlid)]"/>
            <xsl:variable name="rs-id">
              <xsl:choose>
                <xsl:when test="contains($offices/@ref, '#')">
                  <xsl:value-of select="substring-after($offices/@ref, '#')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$offices/@ref"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="officesAL" select="'../../content/xml/authority/offices.xml'"/>
            <xsl:variable name="rs-idno" select="document($officesAL)//tei:item[@xml:id=$rs-id]"/>
            <xsl:for-each select="$offices">
              <xsl:if test="doc-available($officesAL) = fn:true() and $rs-idno/ancestor::tei:list[@type='ecclesiastical_offices']">
                <xsl:value-of select="$rs-idno//tei:term[1]" />
              </xsl:if>
              <xsl:if test="position()!=last()">; </xsl:if>
            </xsl:for-each>
          </field>
          
          <field name="index_occupation">
            <xsl:value-of select="'-'"/> <!-- from AL or <rs type="occupation"> or @role -->
          </field>
          
          <field name="index_relation">
            <xsl:value-of select="'-'"/> <!-- from AL or <rs type="???"> or @role -->
          </field>
          
          <field name="index_inscription_date">
            <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader//tei:origDate"/>
          </field>
          
          <xsl:apply-templates select="current()" />
        </doc>
      </xsl:for-each>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
