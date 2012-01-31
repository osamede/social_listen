<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/"><News>
      <Title>
        <xsl:value-of select="//*[@id='artibodyTitle']"/>
      </Title>
      <Author>
        <xsl:value-of select="//*[@id='media_name']/a[1]"/>
      </Author>
      <Content>
        <xsl:value-of select="//*[@id='artibody']"/>
      </Content>
      <PublishTime>
        <xsl:value-of select="//*[@id='pub_date']"/>
      </PublishTime>
    </News>
  </xsl:template>
</xsl:stylesheet>
