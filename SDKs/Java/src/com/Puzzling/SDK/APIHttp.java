package com.Puzzling.SDK;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.simple.parser.JSONParser;

public class APIHttp {
	public static HttpClient client = new DefaultHttpClient();
	
	/**
	 * Class APIHttp
	 * 
	 * Helper Class for our API. 
	 * Encapsulates GET/POST/PUT/DELETE Http requests on Android. 
	 */
	
	/** 
	 * Helper function; independent of request issued,
	 * parse response and just send back the string read
	 */
	private static String parseResponse(HttpResponse response) throws ClientProtocolException, IOException {
		StatusLine statusLine = response.getStatusLine();
		// wait for the response
	    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
	        ByteArrayOutputStream out = new ByteArrayOutputStream();
	        response.getEntity().writeTo(out);
	        out.close();
	        String responseString = out.toString();
	        return responseString;
	    } else{
	        //Closes the connection.
	        response.getEntity().getContent().close();
	        throw new IOException(statusLine.getReasonPhrase());
	    }
	}
	
	/* ---------------------------- GET ------------------------------ */
	
	private static String _get(String urlpath, List<NameValuePair> headers) throws ClientProtocolException, IOException {
		// construct the body
		HttpGet request = new HttpGet(urlpath);
		if(headers != null) {
			for(NameValuePair pair : headers) {
				request.setHeader(pair.getName(), pair.getValue());
			}
		}
	    HttpResponse response = client.execute(request);
	    return parseResponse(response);
	}
	
	/**
	 * Get parameters should already be in the urlstring
	 * @param urlpath
	 * @return JSON response string
	 */
	public static String get(String urlpath) {
		try {
			return _get(urlpath, null);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty object to fail gracefully
		return "{}";
	}
	/**
	 * Same version as get(urlPath) but with cusotm headers
	 * @param urlpath
	 * @return JSON response string
	 */
	public static String getWithHeaders(String urlpath, List<NameValuePair> headers) {
		try {
			return _get(urlpath, headers);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- POST ------------------------------ */
	
	private static String _post(String urlpath, List<NameValuePair> pairs, List<NameValuePair> headers) throws ClientProtocolException, IOException {
		// Construct request
		HttpPost request = new HttpPost(urlpath);
		if(headers != null) {
			for(NameValuePair pair : headers) {
				request.setHeader(pair.getName(), pair.getValue());
			}
		}
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = client.execute(request);
	    return parseResponse(response);
	}
	/**
	 * POST request takes in a List of value pairs to put into the request body
	 * @param urlpath
	 * @return
	 */
	public static String post(String urlpath, List<NameValuePair> pairs) {
		try {
			return _post(urlpath, pairs, null);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	public static String postWithHeaders(String urlpath, List<NameValuePair> pairs, 
											List<NameValuePair> headers) {
		try {
			return _post(urlpath, pairs, headers);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- PUT ------------------------------ */
	
	private static String _put(String urlpath, List<NameValuePair> pairs, 
								List<NameValuePair> headers) throws ClientProtocolException, IOException {
		// Construct request
		HttpPut request = new HttpPut(urlpath);
		if(headers != null) {
			for(NameValuePair pair : headers) {
				request.setHeader(pair.getName(), pair.getValue());
			}
		}
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = client.execute(request);
	    return parseResponse(response);
	}
	
	public static String put(String urlpath, List<NameValuePair> pairs) {
		try {
			return _put(urlpath, pairs, null);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	public static String putWithHeaders(String urlpath, List<NameValuePair> pairs, 
										List<NameValuePair> headers) {
		try {
			return _put(urlpath, pairs, headers);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- DELETE ------------------------------ */
	
	private static String _delete(String urlpath, List<NameValuePair> pairs, 
								List<NameValuePair> headers) throws ClientProtocolException, IOException {
		// Construct request
		HttpPut request = new HttpPut(urlpath);
		if(headers != null) {
			for(NameValuePair pair : headers) {
				request.setHeader(pair.getName(), pair.getValue());
			}
		}
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = client.execute(new HttpDelete(urlpath));
	    return parseResponse(response);
	}
	public static String delete(String urlpath, List<NameValuePair> pairs) {
		try {
			return _delete(urlpath, pairs, null);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	public static String deleteWithHeaders(String urlpath, List<NameValuePair> pairs, 
											List<NameValuePair> headers) {
		try {
			return _delete(urlpath, pairs, headers);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
}
