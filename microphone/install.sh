sudo echo 'load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1" source_name=echoCancel_source sink_name=echoCancel_sink' >> /etc/pulse/default.pa
sudo echo 'set-default-source echoCancel_source' >> /etc/pulse/default.pa
