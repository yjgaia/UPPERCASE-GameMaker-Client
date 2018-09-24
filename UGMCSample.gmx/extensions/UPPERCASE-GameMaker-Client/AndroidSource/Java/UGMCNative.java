package ${YYAndroidPackageName};

import android.os.AsyncTask;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.yoyogames.runner.RunnerJNILib;

public class UGMCNative {

	private String host;
    private int port;
    private int appPort;

    private PrintWriter out;
    private PrintWriter appOut;

    private boolean connected = false;

    public double NATIVE_DISCONNECT_FROM_SOCKET_SERVER() {
        connected = false;
        return -1;
    }

    public double NATIVE_SEND_TO_SOCKET_SERVER(final String json) {

        new Thread() {

            public void run() {
                if (out != null) {
                    out.write(json + "\r\n");
                    out.flush();
                }
            }

        }.start();

        return -1;
    }

    private void NATIVE_SEND_TO_APP_SERVER(final int status, final String json) {

        new Thread() {

            public void run() {
                if (appOut != null) {
                    appOut.write(status + ":" + json + "\r\n");
                    appOut.flush();
                }
            }

        }.start();
    }
	
	public double NATIVE_CONNECT_TO_SOCKET_SERVER(String host, double port, double appPort) {

		this.host = host;
		this.port = (int) port;
        this.appPort = (int) appPort;

		new ConnectTask().execute();

		return -1;
	}

	public class ConnectTask extends AsyncTask<Void, Void, Void> {

        @Override
        protected Void doInBackground(Void... params) {
            try {

                Socket socket = new Socket(host, port);
                Socket appSocket = new Socket("127.0.0.1", appPort);

                final BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
                appOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(appSocket.getOutputStream())), true);

                connected = true;

                // connected
                NATIVE_SEND_TO_APP_SERVER(0, "");

                new Thread() {

                    public void run() {
                        try {

                            while (connected == true) {

                                String str = reader.readLine();

                                if (str != null) {

                                    // message
                                    NATIVE_SEND_TO_APP_SERVER(2, str);
                                }

                                // disconnected
                                else {
                                    connected = false;

                                    // disconnected
                                    NATIVE_SEND_TO_APP_SERVER(3, "");
                                }
                            }

                        } catch (SocketException e) {
                            e.printStackTrace();

                            connected = false;
                            
                            // disconnected
                            NATIVE_SEND_TO_APP_SERVER(3, "");

                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }

                }.start();

            } catch (ConnectException e) {
                e.printStackTrace();

                // connection failed
                NATIVE_SEND_TO_APP_SERVER(1, "");

            } catch (UnknownHostException e) {
                e.printStackTrace();

                // connection failed
                NATIVE_SEND_TO_APP_SERVER(1, "");

            } catch (IOException e) {
                e.printStackTrace();
            }

            return null;
        }
    }
}
