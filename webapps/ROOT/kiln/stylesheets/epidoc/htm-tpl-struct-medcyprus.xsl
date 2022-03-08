<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">
  <!-- Contains named templates for medcyprus file structure (aka "metadata" aka "supporting data") -->  
   
   <!-- Called from htm-tpl-structure.xsl -->

   <xsl:template name="medcyprus-body-structure">
     <p><b><i18n:text i18n:key="epidoc-xslt-medcyprus-description">Description</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:support/t:p/text()">
         <xsl:apply-templates select="//t:support/t:p" mode="medcyprus-dimensions"/>
       </xsl:when>
       <xsl:when test="//t:support//text()">
         <xsl:apply-templates select="//t:support" mode="medcyprus-dimensions"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>

     <br />
     <b><i18n:text i18n:key="epidoc-xslt-medcyprus-text">Text</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:layoutDesc/t:layout//text()">
         <xsl:value-of select="//t:layoutDesc/t:layout"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text>.</xsl:otherwise>
     </xsl:choose>
     <br />
     <b><i18n:text i18n:key="epidoc-xslt-medcyprus-letters">Letters</i18n:text>: </b>
     <xsl:if test="//t:handDesc/t:handNote/text()">
       <xsl:value-of select="//t:handDesc/t:handNote"/>
     </xsl:if>
     </p>

     <p><b><i18n:text i18n:key="epidoc-xslt-medcyprus-date">Date</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:origin/t:origDate/text()">
         <xsl:value-of select="//t:origin/t:origDate"/>
         <xsl:if test="//t:origin/t:origDate[@type='evidence']">
           <xsl:text>(</xsl:text>
           <xsl:for-each select="tokenize(//t:origin/t:origDate[@evidence],' ')">
             <xsl:value-of select="translate(.,'-',' ')"/>
             <xsl:if test="position()!=last()">
               <xsl:text>, </xsl:text>
             </xsl:if>
           </xsl:for-each>
           <xsl:text>)</xsl:text>
         </xsl:if>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text>.</xsl:otherwise>
     </xsl:choose>
     </p>

     <p><b><i18n:text i18n:key="epidoc-xslt-medcyprus-findspot">Findspot</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:provenance[@type='found'][string(translate(normalize-space(.),' ',''))]">
         <xsl:apply-templates select="//t:provenance[@type='found']" mode="medcyprus-placename"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     <br/>
     <b><i18n:text i18n:key="epidoc-xslt-medcyprus-original-location">Original location</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:origin/t:origPlace/text()">
         <xsl:apply-templates select="//t:origin/t:origPlace" mode="medcyprus-placename"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     <br/>
     <b><i18n:text i18n:key="epidoc-xslt-medcyprus-last-recorded-location">Last recorded location</i18n:text>: </b>
     <xsl:choose>
       <xsl:when test="//t:provenance[@type='observed'][string(translate(normalize-space(.),' ',''))]">
         <xsl:apply-templates select="//t:provenance[@type='observed']" mode="medcyprus-placename"/>
         <!-- Named template found below. -->
         <xsl:call-template name="medcyprus-invno"/> 
       </xsl:when>
       <xsl:when test="//t:msIdentifier//t:repository[string(translate(normalize-space(.),' ',''))]">
         <xsl:value-of select="//t:msIdentifier//t:repository[1]"/>
         <!-- Named template found below. -->
         <xsl:call-template name="medcyprus-invno"/>
       </xsl:when>
       <xsl:otherwise><i18n:text i18n:key="epidoc-xslt-medcyprus-unknown">Unknown</i18n:text></xsl:otherwise>
     </xsl:choose>
     </p>

     <div class="section-container tabs" data-section="tabs">
       <section>
         <p class="title" data-section-title="data-section-title"><a href="#"><i18n:text i18n:key="epidoc-xslt-medcyprus-edition">Interpretive</i18n:text></a></p>
         <div class="content" id="edition" data-section-content="data-section-content">
           <!-- Edited text output -->
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition']">
               <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
       </section>
       <section>
         <p class="title" data-section-title="data-section-title"><a href="#"><i18n:text i18n:key="epidoc-xslt-medcyprus-diplomatic">Diplomatic</i18n:text></a></p>
         <div class="content" id="diplomatic" data-section-content="data-section-content">
           <!-- Edited text output -->
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition']">
               <xsl:with-param name="parm-edition-type" select="'diplomatic'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
       </section>
     </div>

     <div id="apparatus">
       <!-- Apparatus text output -->
       <xsl:variable name="apptxt">
         <xsl:apply-templates select="//t:div[@type='apparatus']"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
     </div>

     <div id="translation">
       <h4 class="slimmer"><i18n:text i18n:key="epidoc-xslt-medcyprus-translation">Translation</i18n:text>:</h4>
       <!-- Translation text output -->
       <xsl:variable name="transtxt">
         <xsl:apply-templates select="//t:div[@type='translation']//t:p"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$transtxt" mode="sqbrackets"/>
     </div>

     <div id="commentary">
       <h4 class="slimmer"><i18n:text i18n:key="epidoc-xslt-medcyprus-commentary">Commentary</i18n:text>:</h4>
       <!-- Commentary text output -->
       <xsl:variable name="commtxt">
         <xsl:apply-templates select="//t:div[@type='commentary']//t:p"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$commtxt" mode="sqbrackets"/>
     </div>
     
     <div id="bibliography">
       <h4 class="slimmer"><i18n:text i18n:key="epidoc-xslt-medcyprus-bibliography">Bibliography</i18n:text>:</h4>
       <xsl:for-each select="//t:div[@type='bibliography']//t:bibl">
         <p>
           <xsl:if test="t:ptr[@target]">
             <xsl:variable name="pointer" select="translate(t:ptr/@target, '#', '')"/>
             <xsl:choose>
               <xsl:when test="doc-available(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml')) = fn:true()">
                 <xsl:variable name="source" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/bibliography.xml'))//t:bibl[@xml:id=$pointer][not(@sameAs)]"/>
                 <xsl:apply-templates select="$source"/></xsl:when>
               <xsl:otherwise><xsl:value-of select="translate(@target, '#', '')"/></xsl:otherwise>
             </xsl:choose>
             <xsl:text> </xsl:text></xsl:if>
           <xsl:apply-templates select="."/>
         </p>
       </xsl:for-each>
       
     </div>
     
     <div id="images">
       <h4 class="slimmer">Images</h4>
       <xsl:choose>
         <xsl:when test="//t:facsimile//t:graphic">
           <xsl:for-each select="//t:facsimile//t:graphic">
             <span>&#160;</span>
             <xsl:apply-templates select="." />
           </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
           <xsl:for-each select="//t:facsimile[not(//t:graphic)]">
             <xsl:text>None available.</xsl:text>
           </xsl:for-each>
         </xsl:otherwise>
       </xsl:choose>
     </div>
   </xsl:template>

   <xsl:template name="medcyprus-structure">
      <xsl:variable name="title">
         <xsl:call-template name="medcyprus-title" />
      </xsl:variable>

      <html>
         <head>
            <title>
               <xsl:value-of select="$title"/>
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>
         <body>
            <h1>
               <xsl:value-of select="$title"/>
            </h1>
            <xsl:call-template name="medcyprus-body-structure" />
         </body>
      </html>
   </xsl:template>

   <xsl:template match="t:dimensions" mode="medcyprus-dimensions">
      <xsl:if test="//text()">
         <xsl:if test="t:width/text()">w: 
            <xsl:value-of select="t:width"/>
            <xsl:if test="t:height/text()">
               <xsl:text> x </xsl:text>
            </xsl:if>
         </xsl:if>
         <xsl:if test="t:height/text()">h: 
            <xsl:value-of select="t:height"/>
         </xsl:if>
         <xsl:if test="t:depth/text()">x d:
            <xsl:value-of select="t:depth"/>
         </xsl:if>
         <xsl:if test="t:dim[@type='diameter']/text()">x diam.:
            <xsl:value-of select="t:dim[@type='diameter']"/>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   
   <xsl:template match="t:placeName|t:rs" mode="medcyprus-placename"> <!-- remove rs? -->
      <xsl:choose>
        <xsl:when test="contains(@ref,'pleiades.stoa.org') or contains(@ref,'geonames.org') or contains(@ref,'slsgazetteer.org')">
            <a>
               <xsl:attribute name="href">
                  <xsl:value-of select="@ref"/>
               </xsl:attribute>
               <xsl:apply-templates/>
            </a>
      </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="medcyprus-invno">
      <xsl:if test="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
         <xsl:text> (Inv. no. </xsl:text>
         <xsl:for-each select="//t:idno[@type='invNo'][string(translate(normalize-space(.),' ',''))]">
            <xsl:value-of select="."/>
            <xsl:if test="position()!=last()">
               <xsl:text>, </xsl:text>
            </xsl:if>
         </xsl:for-each>
         <xsl:text>)</xsl:text>
      </xsl:if>
   </xsl:template>

   <xsl:template name="medcyprus-title">
     <xsl:choose>
       <xsl:when test="//t:titleStmt/t:title/text() and number(substring(//t:publicationStmt/t:idno[@type='filename']/text(),2,5))">
         <xsl:value-of select="//t:publicationStmt/t:idno[@type='filename']/text()"/> 
         <xsl:text>. </xsl:text>
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:titleStmt/t:title/text()">
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:sourceDesc//t:bibl/text()">
         <xsl:value-of select="//t:sourceDesc//t:bibl"/>
       </xsl:when>
       <xsl:when test="//t:idno[@type='filename']/text()">
         <xsl:value-of select="//t:idno[@type='filename']"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:text>EpiDoc example output, medcyprus style</xsl:text>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>

 </xsl:stylesheet>
