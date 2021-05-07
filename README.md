# cf-ddns
Container to run dynamic dns update (for Cloudflare)

```commandline
docker run -e HOST=home.myhost.com -e ZONE=Cloudflare_ZONE_ID -e TOKEN=MYCloudflareAPIToken gr8ninja/cf-ddns 
```