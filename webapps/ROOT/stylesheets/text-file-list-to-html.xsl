<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="response" mode="text-index">
    <table class="tablesorter">
      <thead>
        <tr>
          <!-- Let us assume that all texts have a filename, ID, and
               title. -->
          <!--<th>Filename</th>-->
          <th>ID number</th>
          <th>Title</th>
          <th>Location</th>
          <th>Date</th>
          <!--<th>Author</th>-->
          <!--<th>Editor</th>-->
          <!--<th>Publication Date</th>-->
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="text-index" select="result/doc" >
          <xsl:sort select="str[@name='document_id']"/>
        </xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="result[not(doc)]" mode="text-index">
    <p>There are no files indexed from
    webapps/ROOT/content/xml/<xsl:value-of select="$document_type" />!
    Put some there, index them from the admin page, and this page will
    become much more interesting.</p>
  </xsl:template>

  <xsl:template match="result/doc" mode="text-index">
    <tr>
      <xsl:apply-templates mode="text-index" select="str[@name='file_path']" />
      <!--<xsl:apply-templates mode="text-index" select="str[@name='document_id']" />-->
      <xsl:apply-templates mode="text-index" select="arr[@name='document_title']" />
      <xsl:apply-templates mode="text-index" select="arr[@name='origin_place']" />
      <xsl:apply-templates mode="text-index" select="arr[@name='textual_origin_date']" />
      <!--<xsl:apply-templates mode="text-index" select="arr[@name='author']" />-->
      <!--<xsl:apply-templates mode="text-index" select="arr[@name='editor']" />-->
      <!--<xsl:apply-templates mode="text-index" select="str[@name='publication_date']" />-->
    </tr>
  </xsl:template>

  <xsl:template match="str[@name='file_path']" mode="text-index">
    <xsl:variable name="filename" select="substring-after(., '/')" />
    <td>
      <a href="{kiln:url-for-match($match_id, ($language, $filename), 0)}">
        <xsl:choose>
          <xsl:when test="ancestor::doc/str[@name='document_id']!=''">
            <xsl:value-of select="ancestor::doc/str[@name='document_id']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </td>
  </xsl:template>

  <xsl:template match="str[@name='document_id']" mode="text-index">
    <td><xsl:value-of select="." /></td>
  </xsl:template>

  <xsl:template match="arr[@name='document_title']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>

  <xsl:template match="arr[@name='author']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>

  <xsl:template match="arr[@name='editor']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>

  <xsl:template match="str[@name='publication_date']">
    <td><xsl:value-of select="." /></td>
  </xsl:template>
  
  <xsl:template match="arr[@name='origin_place']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>
  
  <xsl:template match="arr[@name='textual_origin_date']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>

</xsl:stylesheet>
