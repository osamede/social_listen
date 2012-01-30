<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <article>
      <title>
        <xsl:value-of select="//*[@id='artibodyTitle']"/>
      </title>
      <author>
        <xsl:value-of select="//*[@id='media_name']/a[1]"/>
      </author>
      <url>
        
      </url>
      <content>
        <xsl:value-of select="//*[@id='artibody']"/>
      </content>
      <comments>
      
      </comments>
      <publishDate>
        <xsl:value-of select="//*[@id='pub_date']"/>
      </publishDate>
    </article>
  </xsl:template>
</xsl:stylesheet>
