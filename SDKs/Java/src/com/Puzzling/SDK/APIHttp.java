package com.Puzzling.SDK;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpDelete;

import com.Puzzling.SDK.APIConfig;

public class APIHttp {

	/*
	 * Class APIHttp
	 * 
	 * Helper Class for our API. 
	 * Encapsulates GET/POST/PUT/DELETE Http requests on Android. 
	 * @dependency APIConfig.client - globally initiated HttpClient
	 */
	
	/* 
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
	
	private static String _get(String urlpath) throws ClientProtocolException, IOException {
		// construct the body
		HttpGet request = new HttpGet(urlpath);
	    HttpResponse response = APIConfig.client.execute(request);
	    return parseResponse(response);
	}
	
	/**
	 * Get parameters should already be in the urlstring
	 * @param urlpath
	 * @return JSON response string
	 */
	public static String get(String urlpath) {
		try {
			return _get(urlpath);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- POST ------------------------------ */
	
	private static String _post(String urlpath, List<NameValuePair> pairs) throws ClientProtocolException, IOException {
		// Construct request
		HttpPost request = new HttpPost(urlpath);
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = APIConfig.client.execute(request);
	    return parseResponse(response);
	}
	/**
	 * POST request takes in a List of value pairs to put into the request body
	 * @param urlpath
	 * @return
	 */
	public static String post(String urlpath, List<NameValuePair> pairs) {
		try {
			return _post(urlpath, pairs);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- PUT ------------------------------ */
	
	private static String _put(String urlpath, List<NameValuePair> pairs) throws ClientProtocolException, IOException {
		// Construct request
		HttpPut request = new HttpPut(urlpath);
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = APIConfig.client.execute(request);
	    return parseResponse(response);
	}
	
	public static String put(String urlpath, List<NameValuePair> pairs) {
		try {
			return _put(urlpath, pairs);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
	
	/* ---------------------------- DELETE ------------------------------ */
	private static String _delete(String urlpath, List<NameValuePair> pairs) throws ClientProtocolException, IOException {
		// Construct request
		HttpPut request = new HttpPut(urlpath);
		request.setEntity(new UrlEncodedFormEntity(pairs));
	    HttpResponse response = APIConfig.client.execute(new HttpDelete(urlpath));
	    return parseResponse(response);
	}
	public static String delete(String urlpath, List<NameValuePair> pairs) {
		try {
			return _delete(urlpath, pairs);
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		// return empty JSON object to fail gracefully
		return "{}";
	}
}
