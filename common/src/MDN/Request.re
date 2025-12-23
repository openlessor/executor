type t;

type method =
  | GET
  | HEAD
  | POST
  | PUT
  | DELETE
  | CONNECT
  | OPTIONS
  | TRACE
  | PATCH;

type requestRedirect =
  | [@mel.as "error"] Error
  | [@mel.as "follow"] Follow
  | [@mel.as "manual"] Manual;

type requestInit = {
  /**
   * A BodyInit object or null to set request's body.
   */ //body: Null.t<BodyInit.t>,
/**
   * A string indicating how the request will interact with the browser's cache to set request's cache.
   *
   * Note: as of Bun v0.5.7, this is not implemented yet.
   */ //cache: requestCache,
/**
   * A string indicating whether credentials will be sent with the request always, never, or only when sent to a same-origin URL. Sets request's credentials.
   */ //credentials: requestCredentials,
/**
   * A Headers object, an object literal, or an array of two-item arrays to set request's headers.
   */ //headers: HeadersInit.t,
/**
   * A cryptographic hash of the resource to be fetched by request. Sets request's integrity.
   *
   * Note: as of Bun v0.5.7, this is not implemented yet.
   */
  integrity: string,
  /**
   * A boolean to set request's keepalive.
   *
   * Available in Bun v0.2.0 and above.
   *
   * This is enabled by default
   */
  keepalive: bool,
  /**
   * A string to set request's method.
   */
  method: string,
  /**
   * A string to indicate whether the request will use CORS, or will be restricted to same-origin URLs. Sets request's mode.
   */ //mode: requestMode,
/**
   * A string indicating whether request follows redirects, results in an error upon encountering a redirect, or returns the redirect (in an opaque fashion). Sets request's redirect.
   */
  redirect: requestRedirect,
  /**
   * A string whose value is a same-origin URL, "about:client", or the empty string, to set request's referrer.
   */
  referrer: string,
  /**
   * A referrer policy to set request's referrerPolicy.
   */ //referrerPolicy: referrerPolicy,
/**
   * An AbortSignal to set request's signal.
   */ //signal: Null.t<AbortSignal.t>,
/**
   * Enable or disable HTTP request timeout
   */
  timeout: bool,
};

/**
   * Read or write the HTTP headers for this request.
   *
   * @example
   * ```rescript
   * let request = Request.make("https://remix.run/");
   * request->Request.headers->Headers.set("Content-Type", "application/json");
   * request->Request.headers->Headers.set("Accept", "application/json");
   * let res = await fetch(request)
   * ```
   */ //[@mel.get]
 //external headers: t => Headers.t = "headers";
                                                                    /**
   * The URL (as a string) corresponding to the HTTP request
   * @example
   * ```rescript
   * let request = Request.make("https://remix.run/")
   * request->Request.url; // "https://remix.run/";
   * ```
   */
[@mel.get]
external url: t => string = "url";

/**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a string. It will be decoded from UTF-8.
   *
   * When the body is valid latin1, this operation is zero copy.
   */
[@mel.send]
external text: t => Js.promise(string) = "text";

/**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a {@link ReadableStream}.
   *
   * Streaming **outgoing** HTTP request bodies via `fetch()` is not yet supported in
   * Bun.
   *
   * Reading **incoming** HTTP request bodies via `ReadableStream` in `Bun.serve()` is supported
   * as of Bun v0.2.0.
   *
   *
   */ //[@mel.send]
 //external body: t => Null.t(ReadableStream.t('t)) = "body";
                                                                    /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as an ArrayBuffer.
   *
   */ //[@mel.send]
 //external arrayBuffer: t => Js.promise(ArrayBuffer.t) = "arrayBuffer";
                                                                    /**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a JSON object.
   *
   * This first decodes the data from UTF-8, then parses it as JSON.
   *
   */
[@mel.send]
external json: t => Js.promise(Js.Json.t) = "json";

/**
   * Consume the [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) body as a `Blob`.
   *
   * This allows you to reuse the underlying data.
   *
   */ //[@mel.send]
 //external blob: t => Js.promise(Blob.t) = "blob";
                                                                    /**
   * Returns the cache mode associated with request, which is a string indicating how the request will interact with the browser's cache when fetching.
   */ //[@mel.get]
 //external cache: t => requestCache = "cache";
                                                                    /**
   * Returns the credentials mode associated with request, which is a string indicating whether credentials will be sent with the request always, never, or only when sent to a same-origin URL.
   */ //[@mel.get]
 //external credentials: t => requestCredentials = "credentials";
                                                                    /**
   * Returns the kind of resource requested by request, e.g., "document" or "script".
   *
   * //In Bun, this always returns "navigate".
   */ //
 //[@mel.get]
                                                                    //external destination: t => requestDestination = "destination";
                                                                    /**
   * Returns request's subresource integrity metadata, which is a cryptographic hash of the resource being fetched. Its value consists of multiple hashes separated by whitespace. [SRI]
   *
   * This does nothing in Bun right now.
   */ //[@mel.get]
 //external integrity: t => string = "integrity";
                                                                    /**
   * Returns a boolean indicating whether or not request can outlive the global in which it was created.
   *
   * In Bun, this always returns false.
   */
[@mel.get]
external keepalive: t => bool = "keepalive";
/**
   * Returns request's HTTP method, which is "GET" by default.
   */
[@mel.get]
external method: t => method = "method";
/**
   * Returns the mode associated with request, which is a string indicating whether the request will use CORS, or will be restricted to same-origin URLs.
   */ //[@mel.get]
 //external mode: t => requestMode = "mode";
                                                                    /**
   * Returns the redirect mode associated with request, which is a string indicating how redirects for the request will be handled during fetching. A request will follow redirects by default.
   */
[@mel.get]
external redirect: t => requestRedirect = "redirect";
/**
   * Returns the referrer of request. Its value can be a same-origin URL
   * if explicitly set in init, the empty string to indicate no referrer,
   * and "about:client" when defaulting to the global's default. This is
   * used during fetching to determine the value of the `Referer` header
   * of the request being made.
   */
[@mel.get]
external referrer: t => string = "referrer";
/**
   * Returns the referrer policy associated with request. This is used during fetching to compute the value of the request's referrer.
   */ //[@mel.get]
//external referrerPolicy: t => referrerPolicy = "referrerPolicy";
/**
   * Returns the signal associated with request, which is an AbortSignal object indicating whether or not request has been aborted, and its abort event handler.
   */ //[@mel.get]
//external signal: t => AbortSignal.t = "signal";
/** Copy the Request object into a new Request, including the body */ //[@mel.send]
//external clone: t => t = "clone";
/**
   * Read the body from the Request as a {@link FormData} object.
   *
   * This first decodes the data from UTF-8, then parses it as a
   * `multipart/form-data` body or a `application/x-www-form-urlencoded` body.
   *
   * @returns Promise<FormData> - The body of the request as a {@link FormData}.
   */ //[@mel.send]
//  //external formData: t => Js.promise(FormData.t) = "formData";
//
/**
   * Has the body of the request been read?
   *
   * [Request.bodyUsed](https://developer.mozilla.org/en-US/docs/Web/API/Request/bodyUsed)
   */
//[@mel.get]
//external bodyUsed: t => bool = "bodyUsed";
//  external makeFromString: (string, ~requestInit: requestInit=?) => t = "Request";
//
type requestInitWithUrl = {. url: string};

[@mel.new] external make: requestInitWithUrl => t = "Request";

[@mel.new]
external makeFromRequest: (t, ~requestInit: requestInit=?) => t = "Request";
