'use strict';

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  const newVersionCookie = "version=new";
  const oldVersionCookie = "version=old";

  const newSiteDomain = "spikeseed-new.s3-website-eu-west-1.amazonaws.com";
  const oldSiteDomain = "spikeseed-old.s3-website-eu-west-1.amazonaws.com";

  let domain = oldSiteDomain; // Default to old site

  if (headers.cookie) {
    for (let i = 0; i < headers.cookie.length; i++) {
      const cookie = headers.cookie[i].value;

      if (cookie.includes(newVersionCookie)) {
        domain = newSiteDomain;
        break;
      } else if (cookie.includes(oldVersionCookie)) {
        domain = oldSiteDomain;
        break;
      }
    }
  }

  // Modify the request headers to serve content from the selected domain
  request.headers.host = [{ key: 'host', value: domain }];

  callback(null, request);
};
