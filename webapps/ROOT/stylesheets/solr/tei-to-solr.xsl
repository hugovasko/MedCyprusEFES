<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
        which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
  
  <xsl:template match="//tei:term[@type='textType']" mode="facet_inscription_type">
    <field name="inscription_type">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs[@key]" mode="facet_mentioned_institutions">
    <field name="mentioned_institutions">
      <xsl:value-of select="@key"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace[@ref]" mode="facet_ecclesiastical_diocese">
    <xsl:variable name="id" select="substring-after(@ref, '#')"/>
    <xsl:variable name="locationsAL" select="'../../content/xml/authority/locations.xml'"/>
    <field name="ecclesiastical_diocese">
      <xsl:choose>
        <xsl:when test="doc-available($locationsAL) = fn:true() and document($locationsAL)//tei:place[@xml:id=$id]">
          <xsl:value-of select="normalize-space(translate(translate(translate(document($locationsAL)//tei:place[@xml:id=$id]/tei:placeName[@type='diocese'], '/', '／'), '_', ' '), '?', ''))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$id" />
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace[@ref]" mode="facet_administrative_district">
    <xsl:variable name="id" select="substring-after(@ref, '#')"/>
    <xsl:variable name="locationsAL" select="'../../content/xml/authority/locations.xml'"/>
    <field name="administrative_district">
      <xsl:choose>
        <xsl:when test="doc-available($locationsAL) = fn:true() and document($locationsAL)//tei:place[@xml:id=$id]">
          <xsl:value-of select="normalize-space(translate(translate(translate(document($locationsAL)//tei:place[@xml:id=$id]/tei:placeName[@type='district'], '/', '／'), '_', ' '), '?', ''))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$id" />
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace[@ref]" mode="facet_monument_context">
    <xsl:variable name="id" select="substring-after(@ref, '#')"/>
    <xsl:variable name="locationsAL" select="'../../content/xml/authority/locations.xml'"/>
    <field name="monument_context">
      <xsl:choose>
        <xsl:when test="doc-available($locationsAL) = fn:true() and document($locationsAL)//tei:place[@xml:id=$id]">
          <xsl:value-of select="normalize-space(translate(translate(translate(document($locationsAL)//tei:place[@xml:id=$id]/tei:desc[@type='context'], '/', '／'), '_', ' '), '?', ''))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$id" />
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace[@ref]" mode="facet_monument_function">
    <xsl:variable name="id" select="substring-after(@ref, '#')"/>
    <xsl:variable name="locationsAL" select="'../../content/xml/authority/locations.xml'"/>
    <field name="monument_function">
      <xsl:choose>
        <xsl:when test="doc-available($locationsAL) = fn:true() and document($locationsAL)//tei:place[@xml:id=$id]">
          <xsl:value-of select="normalize-space(translate(translate(translate(document($locationsAL)//tei:place[@xml:id=$id]/tei:desc[@type='function'], '/', '／'), '_', ' '), '?', ''))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$id" />
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:support" mode="facet_architectural_context">
    <field name="architectural_context">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>  
  
  <xsl:template match="tei:persName/tei:name[@nymRef]" mode="facet_person_name">
    <field name="person_name">
      <xsl:value-of select="@nymRef"/>
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template name="extra_fields">
    <xsl:call-template name="field_inscription_type"/>
    <xsl:call-template name="field_mentioned_institutions"/>
    <xsl:call-template name="field_ecclesiastical_diocese"/>
    <xsl:call-template name="field_administrative_district"/>
    <xsl:call-template name="field_monument_context"/>
    <xsl:call-template name="field_monument_function"/>
    <xsl:call-template name="field_architectural_context"/>
    <xsl:call-template name="field_person_name"/>
  </xsl:template>
  
  <xsl:template name="field_inscription_type">
    <xsl:apply-templates mode="facet_inscription_type" select="/tei:TEI/tei:teiHeader"/>
  </xsl:template>
  
  <xsl:template name="field_mentioned_institutions">
    <xsl:apply-templates mode="facet_mentioned_institutions" select="//tei:text/tei:body/tei:div[@type='edition']"/>
  </xsl:template>
  
  <xsl:template name="field_ecclesiastical_diocese">
    <xsl:apply-templates mode="facet_ecclesiastical_diocese" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
  </xsl:template>
  
  <xsl:template name="field_administrative_district">
    <xsl:apply-templates mode="facet_administrative_district" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
  </xsl:template>
  
  <xsl:template name="field_monument_context">
    <xsl:apply-templates mode="facet_monument_context" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
  </xsl:template>
  
  <xsl:template name="field_monument_function">
    <xsl:apply-templates mode="facet_monument_function" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
  </xsl:template>
  
  <xsl:template name="field_architectural_context">
    <xsl:apply-templates mode="facet_architectural_context" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support" />
  </xsl:template>
  
  <xsl:template name="field_person_name">
    <xsl:apply-templates mode="facet_person_name" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
  
</xsl:stylesheet>
