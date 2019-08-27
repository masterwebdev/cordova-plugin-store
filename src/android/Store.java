/**
*/
package com.autovitalsinc.store;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Context;
import android.util.Log;


public class Store extends CordovaPlugin {
	private static final String TAG = "FILE STORAGE";

	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
		
		//Log.d(TAG, "start store plugin");

		if(action.equals("savefile")) {
			
			String filename = args.getString(0);
			//String data = args.getString(1).toString();
			String data = args.getString(1);
			String append = args.getString(2);
			Boolean apnd=false;
			
			//Log.d(TAG, append);
			
			if(append.equals("true")){
				apnd=true;
			}
			
			//Log.d(TAG, filename);
			
			savefile(filename,data,apnd,callbackContext);
		}else if(action.equals("readfile")) {
			
			String filename = args.getString(0);
			
			//Log.d(TAG, filename);
			
			readfile(filename,callbackContext);
		}else if(action.equals("truncate")) {
			
			String filename = args.getString(0);
			Integer data = Integer.parseInt(args.getString(1));
			
			truncate(filename,data,callbackContext);
		}else if(action.equals("initdirs")) {
			initdirs(callbackContext);
		}else if(action.equals("storefile")) {
			storefile(" ",callbackContext);
		}
		
		return true;
	}
	
	private void initdirs(final CallbackContext cb) {

		try {
			File file = new File(this.cordova.getActivity().getApplicationContext().getExternalFilesDir(null), "dmpn");
			file.mkdirs();
		    cb.success();
		} catch (Exception e) {
			Log.d(TAG, "INIT DIRS ERROR ");
			cb.error("error");
		}

	}
	
	private void truncate(final String filename, final Integer count, final CallbackContext cb)
	{
	
		FileOutputStream outStream = null;
		
		File filepath = new File(cordova.getActivity().getApplicationContext().getExternalFilesDir(null), "dmpn");		
		String path = filepath.getAbsolutePath() + "/" + filename;
		
		try {
		
	        File file =  new File(path);
	        RandomAccessFile randomAccessFile = new RandomAccessFile(file, "rw");
	        FileChannel fileChannel = randomAccessFile.getChannel();
	        System.out.println("TRUNCATE TO: " + count);
	        System.out.println("Before deleting: " + randomAccessFile.length());
	        fileChannel.transferTo(fileChannel.size() - count, fileChannel.size(), fileChannel);//write data from position(fileChannel.size() - count) to end of file from the orginal file
	        randomAccessFile.setLength(count);//delete the unnecessary data
	        System.out.println("After deleting: " + randomAccessFile.length());
		
		} catch (Exception e) {
			Log.d(TAG, "SAVE FILE ERROR "+path);
			cb.error("error");
		}
		
	}
	
	private void savefile(final String filename, final String data, final Boolean append, final CallbackContext cb) {
		//cordova.getThreadPool().execute(new Runnable() {
		//this.cordova.getActivity().runOnUiThread(new Runnable() {
		//	@Override
        //    public void run() {
				FileOutputStream outStream = null;
				
				File file = new File(cordova.getActivity().getApplicationContext().getExternalFilesDir(null), "dmpn");		
				String path = file.getAbsolutePath() + "/" + filename;
				
				
				//Log.d(TAG, filename);
				//Log.d(TAG, data);
			
				/*try {
					outStream = cordova.getActivity().getApplicationContext().openFileOutput(filename, Context.MODE_PRIVATE);
					outStream.write(data.getBytes());
					outStream.close();
					cb.success();
				} catch (Exception e) {
				    e.printStackTrace();
				    cb.error("error");
				}*/
		
				try {
					outStream = new FileOutputStream(path,append);
			        outStream.write(data.getBytes());
			        outStream.close();
			        //Log.d(TAG, path);
			        cb.success();
				} catch (Exception e) {
					Log.d(TAG, "SAVE FILE ERROR "+path);
				    cb.error("error");
				}
           //}
        //});
		
		return;

	}
	
	private void readfile(final String filename, final CallbackContext cb) {
		
		//cordova.getThreadPool().execute(new Runnable() {
		//this.cordova.getActivity().runOnUiThread(new Runnable() {
		//	@Override
        //    public void run() {
            	
            	File file = new File(cordova.getActivity().getApplicationContext().getExternalFilesDir(null), "dmpn");		
				String path = file.getAbsolutePath() + "/" + filename;
				
				/*try {
					FileInputStream fis = cordova.getActivity().getApplicationContext().openFileInput(filename);
					InputStreamReader isr = new InputStreamReader(fis);
					BufferedReader bufferedReader = new BufferedReader(isr);
					StringBuilder sb = new StringBuilder();
					String line;
					while ((line = bufferedReader.readLine()) != null) {
					    sb.append(line);
					}
					cb.success(sb.toString());
				}catch (IOException e) {
						Log.d(TAG, "READ FILE ERROR "+filename);
						Log.d(TAG, e.getMessage());
						cb.error("error");
					}*/
				
				StringBuilder text = new StringBuilder();

				try {
				    BufferedReader br = new BufferedReader(new FileReader(path));
				    String line;

				    while ((line = br.readLine()) != null) {
				        text.append(line);
				        text.append('\n');
				    }
				    br.close();
				    
				    cb.success(text.toString());
				}
				catch (IOException e) {
					Log.d(TAG, "READ FILE ERROR "+path);
					Log.d(TAG, e.getMessage());
					cb.error("error");
				}
				
        //    }
        //});

	}
	
	private void storefile(String message, final CallbackContext cb) {
	    if (message != null && message.length() > 0) {
	        cb.success(message);
	    } else {
	        cb.error("Expected one non-empty string argument.");
	    }
	}
	
}