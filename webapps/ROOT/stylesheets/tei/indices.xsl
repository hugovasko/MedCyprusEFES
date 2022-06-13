<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- XSLT to convert index metadata and index Solr results into
       HTML. This is the common functionality for both TEI and EpiDoc
       indices. It should be imported by the specific XSLT for the
       document type (eg, indices-epidoc.xsl). -->

  <xsl:import href="to-html.xsl" />

  <xsl:template match="index_metadata" mode="title">
    <xsl:value-of select="tei:div/tei:head" />
  </xsl:template>

  <xsl:template match="index_metadata" mode="head">
    <xsl:apply-templates select="tei:div/tei:head/node()" />
  </xsl:template>

  <xsl:template match="tei:div[@type='headings']/tei:list/tei:item">
    <th scope="col">
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template match="tei:div[@type='headings']">
    <thead>
      <tr>
        <xsl:apply-templates select="tei:list/tei:item"/>
      </tr>
    </thead>
  </xsl:template>
  
  <xsl:template match="result/doc[arr[@name='index_coordinates']]"> <!-- i.e. locations index -->
    <div id="{str[@name='index_id']}" class="monument">
      <h2><xsl:apply-templates select="str[@name='index_item_name']" /></h2>
      <p>
        <b>Type: </b><xsl:value-of select="str[@name='index_item_type']" />
        <br/><b>Greek name: </b><xsl:value-of select="string-join(arr[@name='index_item_alt_name']/str, '; ')"/>
        <br/><b>District: </b><xsl:value-of select="string-join(arr[@name='index_district']/str, '; ')"/>
        <br/><b>Diocese: </b><xsl:value-of select="string-join(arr[@name='index_diocese']/str, '; ')"/>
        <br/><b>Coordinates: </b><xsl:value-of select="string-join(arr[@name='index_coordinates']/str, '; ')"/>
        <br/><b>Construction: </b><xsl:value-of select="string-join(arr[@name='index_construction']/str, '; ')"/>
        <br/><b>Function: </b><xsl:value-of select="string-join(arr[@name='index_function']/str, '; ')"/>
        <br/><b>Context: </b><xsl:value-of select="string-join(arr[@name='index_context']/str, '; ')"/>
        <br/><b>Architectural type: </b><xsl:value-of select="string-join(arr[@name='index_architectural_type']/str, '; ')"/>
        <br/><b>Mural: </b><xsl:value-of select="string-join(arr[@name='index_mural']/str, '; ')"/>
        <br/><b>Conservation: </b><xsl:value-of select="string-join(arr[@name='index_conservation']/str, '; ')"/>
        <br/><b>Donors: </b><xsl:value-of select="string-join(arr[@name='index_donors']/str, '; ')"/>
        <br/><b>Painter: </b><xsl:value-of select="string-join(arr[@name='index_painter']/str, '; ')"/>
        <br/><b>Graffiti: </b><xsl:apply-templates select="arr[@name='index_graffiti']"/>
        <br/><b>External resources: </b><xsl:apply-templates select="arr[@name='index_external_resource']"/>
        <br/><b>Inscriptions bibliography: </b><xsl:apply-templates select="arr[@name='index_inscriptions_bibl']"/>
        <br/><b>Monument bibliography: </b><xsl:apply-templates select="arr[@name='index_monument_bibl']"/>
      </p>
      <h3>Inscriptions: </h3>
      <xsl:apply-templates select="arr[@name='index_instance_location']" />
    </div>
  </xsl:template>

  <xsl:template match="result/doc[not(arr[@name='index_coordinates'])]"> <!-- i.e. all indices excluded locations -->
    <tr>
      <xsl:apply-templates select="str[@name='index_item_name']" />
      <xsl:apply-templates select="str[@name='index_surname']" />
      <xsl:apply-templates select="str[@name='index_abbreviation_expansion']"/>
      <xsl:apply-templates select="str[@name='index_numeral_value']"/>
      <xsl:apply-templates select="arr[@name='language_code']"/>
      <xsl:apply-templates select="arr[@name='index_epithet']" />
      <xsl:apply-templates select="str[@name='index_item_type']" />
      <xsl:apply-templates select="str[@name='index_item_role']" />
      <xsl:apply-templates select="str[@name='index_honorific']" />
      <xsl:apply-templates select="str[@name='index_secular_office']" />
      <xsl:apply-templates select="str[@name='index_dignity']" />
      <xsl:apply-templates select="str[@name='index_ecclesiastical_office']" />
      <xsl:apply-templates select="str[@name='index_occupation']" />
      <xsl:apply-templates select="str[@name='index_relation']" />
      <xsl:apply-templates select="str[@name='index_inscription_date']" />
      <xsl:apply-templates select="arr[@name='index_instance_location']" />
    </tr>
  </xsl:template>

  <xsl:template match="response/result[descendant::doc[arr[@name='index_coordinates']]]"> <!-- i.e. locations index -->
    <div>
        <xsl:apply-templates select="doc"><xsl:sort select="lower-case(.)"/></xsl:apply-templates>
    </div>
  </xsl:template>
  
  <xsl:template match="response/result[not(descendant::arr[@name='index_coordinates'])]"> <!-- i.e. all indices excluded locations -->
    <table class="index tablesorter">
      <xsl:apply-templates select="/aggregation/index_metadata/tei:div/tei:div[@type='headings']" />
      <tbody>
        <xsl:apply-templates select="doc"><xsl:sort select="translate(normalize-unicode(lower-case(.),'NFD'), '&#x0300;&#x0301;&#x0308;&#x0303;&#x0304;&#x0313;&#x0314;&#x0345;&#x0342;' ,'')"/></xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="str[@name='index_abbreviation_expansion']">
    <td>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <xsl:template match="str[@name='index_item_name']">
    <th scope="row">
      <!-- Look up the value in the RDF names, in case it's there. -->
      <xsl:variable name="rdf-name" select="/aggregation/index_names/rdf:RDF/rdf:Description[@rdf:about=current()][1]/*[@xml:lang=$language][1]" />
      <xsl:choose>
        <xsl:when test="normalize-space($rdf-name)">
          <xsl:value-of select="$rdf-name" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </th>
  </xsl:template>
  
  <xsl:template match="str[@name='index_surname']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_honorific']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_secular_office']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_dignity']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template match="str[@name='index_ecclesiastical_office']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_occupation']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_relation']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_inscription_date']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="arr[@name='index_instance_location']">
    <td>
      <ul class="index-instances inline-list">
        <xsl:apply-templates select="str" />
      </ul>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_item_type']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="str[@name='index_item_role']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template match="str[@name='index_numeral_value']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template match="arr[@name='language_code']">
    <td>
      <ul class="inline-list">
        <xsl:apply-templates select="str"/>
      </ul>
    </td>
  </xsl:template>

  <xsl:template match="arr[@name='language_code']/str">
    <li>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>
  
  <xsl:template match="str[@name='index_id']">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>
  
  <xsl:template match="arr[@name='index_epithet']">
    <td>
      <xsl:variable name="epithets">
        <xsl:for-each select="str">
          <xsl:value-of select="."/>
          <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="string-join(distinct-values(tokenize($epithets, ', ')), ', ')"/>
    </td>
  </xsl:template>
  
  <xsl:template match="arr[@name='index_inscriptions_bibl']|arr[@name='index_monument_bibl']">
    <xsl:for-each select="str[.='unpublished']"><xsl:value-of select="."/></xsl:for-each>  
    <xsl:for-each select="str[.!='unpublished']">
        <xsl:variable name="bibl-id">
          <xsl:choose>
            <xsl:when test="contains(., ',')">
              <xsl:value-of select="substring-before(., ',')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bibliography-al" select="concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml')"/>
        <xsl:variable name="bibl" select="document($bibliography-al)//tei:bibl[@xml:id=$bibl-id][not(@sameAs)]"/>
        <a href="{concat('../../concordance/bibliography/',$bibl-id,'.html')}" target="_blank">
          <xsl:choose>
            <xsl:when test="doc-available($bibliography-al) = fn:true() and $bibl//tei:surname and $bibl//tei:date">
              <xsl:for-each select="$bibl//tei:surname[not(parent::*/preceding-sibling::tei:title)]">
                <xsl:apply-templates select="."/>
                <xsl:if test="position()!=last()"> – </xsl:if>
              </xsl:for-each>
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="$bibl//tei:date"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$bibl-id"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      <xsl:if test="contains(., ',')">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring-after(., ',')"/>
      </xsl:if>
        <xsl:if test="position()!=last()">; </xsl:if>
      </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template match="arr[@name='index_graffiti']|arr[@name='index_external_resource']">
    <xsl:for-each select="str">
      <xsl:analyze-string select="." regex="(http:|https:)(\S+?)(\.|\)|\]|;|,|\?|!|:)?(\s|$)">
        <xsl:matching-substring>
          <a target="_blank" href="{concat(regex-group(1),regex-group(2))}"><xsl:value-of select="concat(regex-group(1),regex-group(2))"/></a>
          <xsl:value-of select="concat(regex-group(3),regex-group(4))"/>
        </xsl:matching-substring>
        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
      </xsl:analyze-string>
      <xsl:if test="position()!=last()">; </xsl:if>
    </xsl:for-each>  
  </xsl:template>
  
  
  <xsl:template match="arr[@name='index_instance_location']/str">
    <!-- This template must be defined in the calling XSLT (eg,
         indices-epidoc.xsl) since the format of the location data is
         not universal. -->
    <xsl:call-template name="render-instance-location" />
  </xsl:template>

</xsl:stylesheet>
