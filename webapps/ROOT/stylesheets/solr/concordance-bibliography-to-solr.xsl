<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions">
  
  <!-- Index references to bibliographic items. -->
  
  <xsl:param name="file-path" />
  
  <xsl:template match="/">
    <xsl:variable name="root" select="." />
    <xsl:variable name="bibliography-al" select="concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml')"/>
    <add>
      <xsl:for-each-group select="//tei:body/tei:div[@type='bibliography']//tei:bibl/tei:ptr" group-by="@target">
        <xsl:variable name="target">
          <xsl:choose>
            <xsl:when test="contains(@target, '#')">
              <xsl:value-of select="substring-after(@target, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@target"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bibl" select="document($bibliography-al)//tei:bibl[@xml:id=$target][not(@sameAs)][not(@copyOf)]"/>
        <xsl:for-each-group select="current-group()" group-by="../tei:citedRange">
          <doc>
            <field name="document_type">
              <xsl:text>concordance_bibliography</xsl:text>
            </field>
            <field name="file_path">
              <xsl:value-of select="$file-path" />
            </field>
            <field name="concordance_bibliography_ref">
              <xsl:value-of select="$target" />
            </field>
            <field name="concordance_bibliography_date"> 
              <xsl:if test="doc-available($bibliography-al) = fn:true()">
                <xsl:value-of select="document($bibliography-al)//tei:bibl[not(@sameAs)][not(@copyOf)][@xml:id=$target]//tei:date[1]" />
              </xsl:if>
            </field>
            <field name="concordance_bibliography_cited_range">
              <xsl:value-of select="../tei:citedRange" />
            </field>
            <field name="concordance_bibliography_type">
              <xsl:choose>
                <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl[ancestor::tei:div[@xml:id]]">
                  <xsl:value-of select="$bibl/ancestor::tei:div[@xml:id][1]/@xml:id"/>
                </xsl:when>
                <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl[ancestor::tei:listBibl[@xml:id]]">
                  <xsl:value-of select="$bibl/ancestor::tei:listBibl[@xml:id][1]/@xml:id"/>
                </xsl:when>
              </xsl:choose>
              <!-- the following is used in MedCyprus to be able to retrieve all entries that should be included both in the 'monuments' and 'inscriptions' sections -->
              <xsl:if test="$bibl/ancestor::tei:body//tei:bibl[translate(@copyOf,'#','')=$target]">COPY</xsl:if>
            </field>
            <!-- the concordance_bibliography_listed field is used to display just one entry for each bibliographic reference in the bibl. list -->
            <xsl:if test="fn:position()=1">
              <field name="concordance_bibliography_listed">
                <xsl:text>yes</xsl:text>
              </field>
            </xsl:if>
            <!-- the concordance_bibliography_short field is used for sorting the bib. references in the bibl. list -->
            <field name="concordance_bibliography_short">
              <xsl:variable name="abbreviation">  
                <xsl:choose>
                  <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl//tei:bibl[@type='abbrev']">
                    <xsl:value-of select="$bibl//tei:bibl[@type='abbrev'][1]"/>
                  </xsl:when>
                  <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl//tei:title[@type='short']">
                    <xsl:value-of select="$bibl//tei:title[@type='short'][1]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl[ancestor::tei:div[@xml:id='authored_editions']]">
                        <xsl:for-each select="$bibl//tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title[not(@type='short')])]">
                          <xsl:value-of select="."/>
                          <xsl:if test="position()!=last()"> – </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$bibl//tei:date/text()"><xsl:text> </xsl:text>
                          <xsl:value-of select="$bibl//tei:date"/></xsl:if>
                      </xsl:when>
                      <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl//tei:surname and $bibl//tei:date">
                        <xsl:for-each select="$bibl//tei:surname[not(parent::*/preceding-sibling::tei:title[not(@type='short')])]">
                          <xsl:value-of select="."/>
                          <xsl:if test="position()!=last()"> – </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="$bibl//tei:date/text()"><xsl:text> </xsl:text>
                          <xsl:value-of select="$bibl//tei:date"/></xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$target"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:value-of select="lower-case(translate($abbreviation, 'Łł', 'Ll'))"/>
            </field>
            <xsl:apply-templates select="current-group()/../tei:citedRange" />
          </doc>
        </xsl:for-each-group>
      </xsl:for-each-group>
      
      <!-- to include also the bibliographic entries that are not cited in <div type="bibliography"> with a <citedRange> -->
      <xsl:if test="doc-available($bibliography-al) = fn:true()">
        <xsl:variable name="all_cited_bibl">
          <xsl:for-each select="$root//tei:div[@type='bibliography']//tei:bibl[descendant::tei:citedRange]/tei:ptr/@target">
            <!--  -->
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="contains(., '#')">
                <xsl:value-of select="substring-after(., '#')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each-group select="document($bibliography-al)//tei:bibl[not(@sameAs)][not(@copyOf)][not(contains($all_cited_bibl, concat(' ',@xml:id,' ')))]" group-by="@xml:id"> 
          <doc>
            <field name="document_type">
              <xsl:text>concordance_bibliography</xsl:text>
            </field>
            <field name="concordance_bibliography_ref">
              <xsl:value-of select="@xml:id" />
            </field>
            <field name="concordance_bibliography_date"> 
              <xsl:value-of select="descendant::tei:date[1]" />
            </field>
            <field name="concordance_bibliography_type">
                <xsl:choose>
                  <xsl:when test="ancestor::tei:div[@xml:id]"><xsl:value-of select="ancestor::tei:div[@xml:id][1]/@xml:id"/></xsl:when>
                  <xsl:when test="ancestor::tei:listBibl[@xml:id]"><xsl:value-of select="ancestor::tei:listBibl[@xml:id][1]/@xml:id"/></xsl:when>
                </xsl:choose>
              <!-- the following is used in MedCyprus to be able to retrieve all entries that should be included both in the 'monuments' and 'inscriptions' sections -->
              <xsl:variable name="id" select="@xml:id"/>
              <xsl:if test="ancestor::tei:body//tei:bibl[translate(@copyOf,'#','')=$id]">COPY</xsl:if>
            </field>
            <!-- the concordance_bibliography_listed field is used to display just one entry for each bibliographic reference in the bibl. list -->
            <field name="concordance_bibliography_listed">
              <xsl:text>yes</xsl:text>
            </field>
            <!-- the concordance_bibliography_short field is used for sorting the bib. references in the bibl. list -->
            <field name="concordance_bibliography_short">
              <xsl:variable name="abbreviation">
                <xsl:choose>
                  <xsl:when test="descendant::tei:bibl[@type='abbrev']">
                    <xsl:value-of select="descendant::tei:bibl[@type='abbrev'][1]"/>
                  </xsl:when>
                  <xsl:when test="descendant::tei:title[@type='short']">
                    <xsl:value-of select="descendant::tei:title[@type='short'][1]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="ancestor::tei:div[@xml:id='authored_editions']">
                        <xsl:for-each select="descendant::tei:name[@type='surname'][not(parent::*/preceding-sibling::tei:title[not(@type='short')])]">
                          <xsl:value-of select="."/>
                          <xsl:if test="position()!=last()"> – </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="descendant::tei:date/text()"><xsl:text> </xsl:text>
                          <xsl:value-of select="descendant::tei:date"/></xsl:if>
                      </xsl:when>
                      <xsl:when test="descendant::tei:surname and descendant::tei:date">
                        <xsl:for-each select="descendant::tei:surname[not(parent::*/preceding-sibling::tei:title[not(@type='short')])]">
                          <xsl:value-of select="."/>
                          <xsl:if test="position()!=last()"> – </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="descendant::tei:date/text()"><xsl:text> </xsl:text>
                          <xsl:value-of select="descendant::tei:date"/></xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@xml:id"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:value-of select="lower-case(translate($abbreviation, 'Łł', 'Ll'))"/>
            </field>
            <xsl:apply-templates select="current-group()" />
          </doc>
        </xsl:for-each-group>
      </xsl:if>
      
    </add>
  </xsl:template>
  
  <xsl:template match="tei:citedRange">
    <field name="concordance_bibliography_item">
      <xsl:variable name="filename" select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']"/>
      <xsl:choose>
        <xsl:when test="starts-with($filename, 'GVCyr') or starts-with($filename, 'IGCyr')">
          <xsl:value-of select="lower-case($filename)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filename" />
        </xsl:otherwise>
      </xsl:choose>
      
    </field>
  </xsl:template>
  
</xsl:stylesheet>
