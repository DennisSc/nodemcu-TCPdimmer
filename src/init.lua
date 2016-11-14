print("Initializing...")
print("reading last dimmer values from memory..")

file.open("valueR.txt","r")
LED1_R_current = tonumber(file.readline())
file.close()
print("read "..LED1_R_current.."\r\n")

file.open("valueG.txt","r")
LED1_G_current = tonumber(file.readline())
file.close()
print("read "..LED1_G_current.."\r\n")

file.open("valueB.txt","r")
LED1_B_current = tonumber(file.readline())
file.close()
print("read "..LED1_B_current.."\r\n")



ws2812.init(ws2812.MODE_SINGLE)
buffer =  ws2812.newBuffer(1, 3)
buffer:fill(LED1_R_current, LED1_G_current, LED1_B_current)
ws2812.write(buffer)

               

LED1_R_target=000
LED1_G_target=000
LED1_B_target=000


Fadetime1=5000


Stepcounter1=0
PosStepcounter1=0
DimTimer1=0

Stepcounter2=0
PosStepcounter2=0
DimTimer2=0

Stepcounter3=0
PosStepcounter3=0
DimTimer3=0



DimTimer4=10
mycounter=0

wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","password")


srv=net.createServer(net.TCP) 
  srv:listen(43333,function(conn) 
    conn:on("receive",function(conn,payload)
         
        print("Input: "..payload) 
         
          if string.find(payload,"RGB1") then

      			  LED1_R_target=tonumber(string.sub(payload, 6, 8) )
      			  print("Received RGB1 red value: "..LED1_R_target)
      			  print("saving dimmer value to memory..")
      			  file.open("valueR.txt","w")
      			  file.writeline(LED1_R_target)
      			  file.close()

              LED1_G_target=tonumber(string.sub(payload, 10, 12) )
              print("Received RGB11 green value: "..LED1_G_target)
              print("saving dimmer value to memory..")
              file.open("valueG.txt","w")
              file.writeline(LED1_G_target)
              file.close()

              LED1_B_target=tonumber(string.sub(payload, 14, 16) )
              print("Received RGB1 blue value: "..LED1_B_target)
              print("saving dimmer value to memory..")
              file.open("valueB.txt","w")
              file.writeline(LED1_B_target)
              file.close()
             
              conn:close()
           
              Stepcounter1=(LED1_R_target)-(LED1_R_current)
     
              if (Stepcounter1) < 0 then
                   PosStepcounter1=(Stepcounter1)*-1
              else PosStepcounter1=(Stepcounter1)
              end
     
              if (PosStepcounter1) == 0 then
                   PosStepcounter1=(PosStepcounter1)+1
              else PosStepcounter1=(PosStepcounter1)
              end
          
               DimTimer1=(Fadetime1)/(PosStepcounter1)

              if (DimTimer1) == 0 then 
                   DimTimer1=(DimTimer1)+1
              else DimTimer1=(DimTimer1)
              end



              Stepcounter2=(LED1_G_target)-(LED1_G_current)
     
              if (Stepcounter2) < 0 then
                   PosStepcounter2=(Stepcounter2)*-1
              else PosStepcounter2=(Stepcounter2)
              end
     
              if (PosStepcounter2) == 0 then
                   PosStepcounter2=(PosStepcounter2)+1
              else PosStepcounter2=(PosStepcounter2)
              end
          
               DimTimer2=(Fadetime1)/(PosStepcounter2)

              if (DimTimer2) == 0 then 
                   DimTimer2=(DimTimer2)+1
              else DimTimer2=(DimTimer2)
              end



              Stepcounter3=(LED1_B_target)-(LED1_B_current)
     
              if (Stepcounter3) < 0 then
                   PosStepcounter3=(Stepcounter3)*-1
              else PosStepcounter3=(Stepcounter3)
              end
     
              if (PosStepcounter3) == 0 then
                   PosStepcounter3=(PosStepcounter3)+1
              else PosStepcounter3=(PosStepcounter3)
              end
          
               DimTimer3=(Fadetime1)/(PosStepcounter3)

              if (DimTimer3) == 0 then 
                   DimTimer3=(DimTimer3)+1
              else DimTimer3=(DimTimer3)
              end





              print (Fadetime1)
              print (Stepcounter1)
              print (PosStepcounter1)
              print (DimTimer1)
              print (LED1_current)
              print (LED1_target)


				      tmr.alarm(0, (DimTimer1), 1, function() 
                    if LED1_R_current < LED1_R_target then 
                         LED1_R_current = (LED1_R_current + 1) 
                         --pwm.setduty(3, LED1_current)
					          elseif LED1_R_current > LED1_R_target then 
                         LED1_R_current = (LED1_R_current - 1) 
                         --pwm.setduty(3, LED1_current)
					          elseif LED1_R_current == LED1_R_target then 
						             tmr.stop(0)
                    end
				      end) --end timer function


              tmr.alarm(1, (DimTimer2), 1, function() 
                    if LED1_G_current < LED1_G_target then 
                         LED1_G_current = (LED1_G_current + 1) 
                         --pwm.setduty(3, LED1_current)
                    elseif LED1_G_current > LED1_G_target then 
                         LED1_G_current = (LED1_G_current - 1) 
                         --pwm.setduty(3, LED1_current)
                    elseif LED1_G_current == LED1_G_target then 
                         tmr.stop(1)
                    end
              end) --end timer function


              tmr.alarm(2, (DimTimer3), 1, function() 
                    if LED1_B_current < LED1_B_target then 
                         LED1_B_current = (LED1_B_current + 1) 
                         --pwm.setduty(3, LED1_current)
                    elseif LED1_B_current > LED1_B_target then 
                         LED1_B_current = (LED1_B_current - 1) 
                         --pwm.setduty(3, LED1_current)
                    elseif LED1_B_current == LED1_B_target then 
                         tmr.stop(2)
                    end
              end) --end timer function


              tmr.alarm(3, (DimTimer4), 1, function() 
                    mycounter = mycounter+DimTimer4
                    buffer:fill(LED1_R_current, LED1_G_current, LED1_B_current)
                    ws2812.write(buffer)
                    print(LED1_R_current..","..LED1_G_current..","..LED1_B_current.."\r")
                    if mycounter > Fadetime1 then
                      mycounter=0
                      print("Red: "..LED1_R_current.."\n")
                      print("Green: "..LED1_G_current.."\n")
                      print("Blue: "..LED1_B_current.."\n")
                      tmr.stop(3)
                      
                    end
                    
              end) --end timer function




		      end -- end if
     
    end) -- end srv conn:on receive function

    conn:on("sent",function(conn)
        print("Closing connection")
        conn:close()
    end) -- end srv conn:on sent function

  end) -- end srv:listen function

print ("rgb led dimmer TCP node")
print ("Based on QuinLED_ESP8266_V0.4")
print ("Version 0.8 (c) 2016 by DennisSc")
