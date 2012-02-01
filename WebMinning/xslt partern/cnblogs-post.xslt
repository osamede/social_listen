<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <documents>
      <post>
        <title>
          <xsl:value-of select="//a[@id='topics']/div/h1[@class='postTitle']/a/text()"/>
        </title>
        
        <author>
          <xsl:value-of select="//*[@id='content']/div[1]/p/a[1]/@href"/>
        </author>
        
        <url>

        </url>
        
        <content>
          <xsl:value-of select="//*[@id='cnblogs_post_body']"/>
        </content>
        
        <viewCount>
          <xsl:value-of select="//*[@id='content']/div[1]/p/text()[2]"/>

        </viewCount>
        
        <publishTime>
          <xsl:value-of select="//*[@id='content']/div[1]/p/text()[1]"/>
        </publishTime>
        
      <commentCount>
        <xsl:value-of select="//*[@id='content']/div[1]/p/a[2]"/>
      </commentCount>
        
      </post>
      <xsl:for-each select="//*[@id='comments']/div[@class='post']">
        <comment>
          <publishTime>
            <xsl:value-of select="div[@class='postfoot']/span"/>
          </publishTime>
          <author>
            <xsl:value-of select="div[@class='postfoot']/a[1]/@href"/>
          </author>

          <postUrl>
            <xsl:value-of select="//a[@id='topics']/div/h1[@class='postTitle']/a/@href"/>
          </postUrl>

          <content>
            <xsl:value-of select="span[@class='blog_comment_body']"/>
          </content>
        </comment>
      </xsl:for-each>
    </documents>
    
  </xsl:template>
</xsl:stylesheet>
