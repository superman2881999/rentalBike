package com.example.ecobike_rental;

import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONException;
import org.json.JSONObject;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "Transaction";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("transaction")) {
                    String key = "BLSSBlwOmxo=";
                    String url = "https://ecopark-system-api.herokuapp.com/api/card/processTransaction";
                    JSONObject bodyRequest;
                    try {
                        JSONObject transaction = new JSONObject();
                        transaction.put("command", methodCall.argument("command"));
                        transaction.put("cardCode", methodCall.argument("codeCard"));
                        transaction.put("owner", methodCall.argument("owner"));
                        transaction.put("cvvCode", methodCall.argument("cvvCode"));
                        transaction.put("dateExpired", methodCall.argument("dateExpired"));
                        transaction.put("transactionContent", methodCall.argument("transactionContent"));
                        transaction.put("amount", methodCall.argument("amount"));
                        transaction.put("createdAt", methodCall.argument("createdAt"));

                        JSONObject obj = new JSONObject();
                        obj.put("secretKey", key);
                        obj.put("transaction", transaction);

                        String hashCode = md5(obj.toString());

                        bodyRequest = new JSONObject();
                        bodyRequest.put("version", "1.0.1");
                        bodyRequest.put("transaction", transaction);
                        bodyRequest.put("appCode", "CWr2Fgjdclc=");
                        bodyRequest.put("hashCode", hashCode);

                        JsonObjectRequest request = new JsonObjectRequest(Request.Method.PATCH, url, bodyRequest,
                                new Response.Listener<JSONObject>(){
                            @Override
                            public void onResponse(JSONObject response) {
                                try {
                                    Log.v("TAG",response.getString("errorCode"));
                                    result.success(response.getString("errorCode"));
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        },
                                new Response.ErrorListener(){
                                    @Override
                                    public void onErrorResponse(VolleyError error){
                                        Log.e("TAG", "JsonArrayRequest onErrorResponse: " + error.getMessage());
                                    }
                                });
                        VolleySingleton.getInstance(getBaseContext()).getRequestQueue().add(request);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }else if(methodCall.method.equals("resetMoney")){
                    String url = "https://ecopark-system-api.herokuapp.com/api/card/reset-balance";
                    JSONObject transaction;
                    try {
                        transaction = new JSONObject();
                        transaction.put("cardCode", methodCall.argument("codeCard"));
                        transaction.put("owner", methodCall.argument("owner"));
                        transaction.put("cvvCode", methodCall.argument("cvvCode"));
                        transaction.put("dateExpired", methodCall.argument("dateExpired"));

                        JsonObjectRequest request = new JsonObjectRequest(Request.Method.PATCH, url, transaction,
                                new Response.Listener<JSONObject>(){
                                    @Override
                                    public void onResponse(JSONObject response) {
                                        try {
                                            Log.v("TAG",response.getString("errorCode"));
                                            result.success(response.getString("errorCode"));
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                },
                                new Response.ErrorListener(){
                                    @Override
                                    public void onErrorResponse(VolleyError error){
                                        Log.e("TAG", "JsonArrayRequest onErrorResponse: " + error.getMessage());
                                    }
                                });
                        VolleySingleton.getInstance(getBaseContext()).getRequestQueue().add(request);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

            }
        });
    }
    public static String md5(final String s) {
        final String MD5 = "MD5";
        try {
            // Create MD5 Hash
            MessageDigest digest = java.security.MessageDigest
                    .getInstance(MD5);
            digest.update(s.getBytes());
            byte messageDigest[] = digest.digest();

            // Create Hex String
            StringBuilder hexString = new StringBuilder();
            for (byte aMessageDigest : messageDigest) {
                String h = Integer.toHexString(0xFF & aMessageDigest);
                while (h.length() < 2)
                    h = "0" + h;
                hexString.append(h);
            }
            return hexString.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return "";
    }
}