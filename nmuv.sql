SELECT
  CASE
  WHEN lower(fv.visitreferrer) LIKE '%trc.taboola.com%'
    OR lower(fv.visitreferrer) LIKE '%paid.outbrain.com%'
    OR lower(subchannel) = 'content marketing'
    THEN 'content marketing'
  WHEN lower(pr.subchannel) != 'unknown' THEN pr.subchannel
  WHEN lower(fv.visitreferrer) LIKE '%google.%'-- Organic search!
    OR lower(fv.visitreferrer) LIKE '%bing.%'
    OR lower(fv.visitreferrer) LIKE '%yahoo.%'
    OR lower(fv.visitreferrer) LIKE '%xfinity.%'
    OR lower(fv.visitreferrer) LIKE '%aol.com%'
    OR lower(fv.visitreferrer) LIKE '%duckduckgo.com%'
    OR lower(fv.visitreferrer) LIKE '%ask.com%'
    OR lower(fv.visitreferrer) LIKE '%wow.com%'
    THEN CASE
    WHEN ep.entrypagecategorydescription IN ('Logged in HomePage', 'Loggged Out HomePage') THEN 'organic brand'
    ELSE 'organic nonbrand'
    END
  WHEN lower(fv.visitreferrer) LIKE '%facebook.%'-- Social media
    OR lower(fv.visitreferrer) LIKE '%twitter.%'
    OR lower(fv.visitreferrer) LIKE '%youtube.%'
    THEN 'social media organic'
  WHEN lower(fv.visitreferrer) LIKE '%familytreemaker.com%'
    OR lower(fv.visitreferrer) LIKE '%findagrave.com%'
    OR lower(fv.visitreferrer) LIKE '%fold3.com%'
    OR lower(fv.visitreferrer) LIKE '%genealogy.com%'
    OR lower(fv.visitreferrer) LIKE '%newspapers.com%'
    OR lower(fv.visitreferrer) LIKE '%progenealogists.com%'
    OR lower(fv.visitreferrer) LIKE '%archives.com%'
    OR (lower(fv.visitreferrer)       LIKE '%ancestry%'-- US ancestry
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.co.uk%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.ca%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.de%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.se%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.mx%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.it%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.fr%'
      AND lower(fv.visitreferrer) NOT LIKE '%ancestry.com.au%'
    )
    THEN 'internal referrals'
  WHEN lower(ep.entrypagenamedescription) LIKE '%geo redirect%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.co.uk%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.com.au%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.ca%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.de%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.se%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.mx%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.it%'
    OR lower(fv.visitreferrer) LIKE '%ancestry.fr%'
    THEN 'geo-redirect'
  WHEN fv.visitreferrer != '0'THEN 'external referrals'
  WHEN ep.entrypagecategorydescription IN ('Logged in HomePage', 'Logged Out HomePage')
    OR len(fv.pageurl) - len(replace(fv.pageurl, '/', '')) < 4
    THEN 'direct homepage'
  ELSE 'direct non-homepage'
  END AS segment,

case when lower(subchannel)  = 'affiliate external'
    or lower(subchannel)  = 'affiliate internal'
    or lower(subchannel)  = 'digital video'
    or lower(subchannel)  = 'display'
    or lower(subchannel)  = 'external paid media'
    or lower(subchannel)  = 'partners'
    or lower(subchannel)  = 'social media paid'
    or lower(subchannel)  = 'paid search gdn'
    or segment = 'content marketing'
    then 'digital channels'
   when  (subchannel like '%Email%'
    or lower(subchannel) = 'external list'
    or lower(subchannel)  = 'internal list')
    then 'email'
   when (segment = 'social media organic'
    or lower(subchannel)  = 'social media natural'
    or segment ='direct non-homepage'
    or segment = 'external referrals')
    then 'referrals'          
  when (segment = 'direct homepage'
    or segment = 'organic brand'
    or lower(subchannel)  = 'paid search – brand'
    or lower(subchannel) = 'direct'
    or lower(subchannel)  = 'tv'
    or lower(subchannel)  = 'tv brand/pr'
    or lower(subchannel)  = 'tv long form'
    or lower(subchannel)  = 'tv short form'
    or lower(subchannel)  = 'trade'
    or lower(subchannel)  = 'radio short form'
    or lower(subchannel)  = 'radio long form'
    or lower(subchannel)  = 'newspaper brand/pr'
    or lower(subchannel) = 'newspaper brand/pr'
    or lower(subchannel)  = 'newspaper brand/pr'
    or lower(subchannel)  = 'magazine brand/pr'
    or lower(subchannel)  = 'online brand/pr'
    or lower(subchannel)  = 'radio brand/pr')
    then 'brand'
  when (segment = 'organic nonbrand'
     or lower(subchannel)  = 'paid search – nonbrand'
     or lower(segment) = 'unknown'
     or lower(subchannel)  = 'search')
     then 'search engine non-brand' 
 when segment = 'internal referrals'  
    or segment = 'geo-redirect'
    or lower(subchannel)  = 'ios app'
    or lower(subchannel)  = 'findagrave'
    or lower(subchannel)  = 'android app'
    or lower(subchannel)  = 'ftm software integration'
    or lower(subchannel) = 'windows app'
    then 'internal'
  else 'other'
end as traffictype,

  CASE
  WHEN fv.entryusertypeid = 0 THEN 'nr visitor'
  WHEN fv.entryusertypeid = 5 THEN 'previous subscriber'
  WHEN fv.entryusertypeid = 7 THEN 'ancestry registrant'
  ELSE 'other'
  END AS usertype,

  CASE
  WHEN entrypagecategorydescription = 'help AND advice articles'
    OR entrypagecategorydescription = 'help/faq'
    OR entrypagecategorydescription = 'merlin'
    OR entrypagecategorydescription = 'online community support'
    OR entrypagecategorydescription = 'message boards'
    THEN 'other'
  WHEN entrypagecategorydescription = 'search forms'
    OR entrypagecategorydescription = 'search results'
    THEN 'search'
  ELSE entrypagecategorydescription
  END AS entrypage
, trunc(fv.servertimemst) AS servermst
, COUNT(DISTINCT fv.visitorid) AS visitors
, COUNT(fv.visitorid) AS visits
, SUM(fv.visits) AS visitssum
, SUM(fv.bouncedvisit) AS bouncedvisits
, COUNT(DISTINCT fv.prospectid) AS prospects
, COUNT(DISTINCT fv.ucdmid) AS ucdmids
, SUM(fv.pageviews) AS pageviews
, SUM(fv.netbillthroughquantity) AS netbillthrus
, SUM(fv.contentview) AS contentviews
, SUM(fv.denies) AS denies
, SUM(fv.contentsuccess) AS contentsuccesses
, SUM(fv.freetrialorders) AS freetrialorders
, SUM(fv.hardofferorders) AS hardofferorders
, si.site
, si.locality
, ua.devicegroupdescription
, ua.devicetypedescription
, ep.entrypagecategorydescription
, fv.lastofferpage
, vt.visitusertypedescription
, fv.entryusertypeid
, pr.subchannel
FROM fact_visits AS fv
right join dim_date as dy on dy.datevalue=trunc(fv.servertimemst) 
JOIN dim_site          AS si ON fv.siteid = si.siteid
JOIN dim_useragent     AS ua ON fv.useragentstring = ua.useragentstring
JOIN dim_entrypagename AS ep ON fv.entrypagenameid = ep.entrypagenameid
JOIN dim_promotion     AS pr ON fv.firstpromotionid = pr.promotionid
JOIN dim_visitusertype AS vt ON fv.visitusertypeid = vt.visitusertypeid
WHERE trunc(fv.servertimemst) >= dateadd('day',-750, getdate())
  AND visitnumber != 0 AND entryusertypeid IN (0,5,6,7,8,10,11)
GROUP BY
  site
, locality
, lastofferpage
, entryusertypeid
, entrypagecategorydescription
, devicegroupdescription
, devicetypedescription
, visitusertypedescription
, subchannel
, trunc(servertimemst)
, segment
