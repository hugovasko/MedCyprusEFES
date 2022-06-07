<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of persons in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:persName[not(@type='divine' or @type='sacred')][ancestor::tei:div/@type='edition']" group-by="concat(string-join(descendant::tei:name, ' '), '-', ancestor::tei:TEI/tei:teiHeader//tei:origDate)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="string-join(descendant::tei:name[@type='forename'], ' ')" />
          </field>
          <field name="index_surname">
            <xsl:value-of select="string-join(descendant::tei:name[@type='surname'], ' ')"/>
          </field>
          <field name="index_item_type">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_honorific">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_secular_office">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_dignity">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_ecclesiastical_office">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_occupation">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_relation">
            <xsl:value-of select="'-'"/>
          </field>
          <field name="index_inscription_date">
            <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader//tei:origDate"/>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
