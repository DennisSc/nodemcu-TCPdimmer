print("Initializing...")
print("reading last color values from memory..")

file.open("valueR.txt","r")
LED1_R_current = tonumber(file.readline())
file.close()
file.open("valueG.txt","r")
LED1_G_current = tonumber(file.readline())
file.close()
file.open("valueB.txt","r")
LED1_B_current = tonumber(file.readline())
file.close()

print("read RGB "..LED1_R_current..","..LED1_G_current..","..LED1_B_current.."\r\n")



ws2812.init(ws2812.MODE_SINGLE)
buffer =  ws2812.newBuffer(5, 3)
buffer:fill(LED1_G_current, LED1_R_current, LED1_B_current)
ws2812.write(buffer)


DimTimer4=10 -- send to ws2812 every 10 ms
Fadetime1=7000  -- each fade should last 5 seconds


-- initialize target values

LED1_R_target=000
LED1_G_target=000
LED1_B_target=000


-- initialize counter helpers
-- red counter
Stepcounter1=0
PosStepcounter1=0
DimTimer1=0
-- green counter
Stepcounter2=0
PosStepcounter2=0
DimTimer2=0
-- blue counter
Stepcounter3=0
PosStepcounter3=0
DimTimer3=0
-- send counter; we send independently of the individual color counters
mycounter=0


-- init wifi
wifi.setmode(wifi.STATION)
wifi.sta.sethostname("esp-rgb-dimmer01")
wifi.sta.config("SSID","password")



-- start server
srv=net.createServer(net.TCP) 
  srv:listen(43333,function(conn) 
    conn:on("receive",function(conn,payload)
         
        print("Input: "..payload) 
         
          if string.find(payload,"RGB1") then

              LED1_R_target=tonumber(string.sub(payload, 6, 8) )
              LED1_B_target=tonumber(string.sub(payload, 14, 16) )
              LED1_G_target=tonumber(string.sub(payload, 10, 12) )
              print("Received RGB1 red value:   "..LED1_R_target)
              print("Received RGB1 blue value:  "..LED1_B_target)
              print("Received RGB1 green value: "..LED1_G_target)
              print("saving new color values to memory..")

              file.open("valueR.txt","w")
              file.writeline(LED1_R_target)
              file.close()

              file.open("valueG.txt","w")
              file.writeline(LED1_G_target)
              file.close()

              file.open("valueB.txt","w")
              file.writeline(LED1_B_target)
              file.close()
             
              conn:close() -- we have all needed data so we can close the connection
              mycounter=0 -- reset send timer counter to start new fade interval

              
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





              -- print (Fadetime1)
              -- print (Stepcounter1)
              -- print (PosStepcounter1)
              -- print (DimTimer1)
              -- print (LED1_R_current)
              print ("\rCommand received.\n")
              print ("going from "..LED1_R_current..","..LED1_G_current..","..LED1_B_current.." to "..LED1_R_target..","..LED1_G_target..","..LED1_B_target.." in "..(Fadetime1 / DimTimer4).." steps, sending to\r\nthe ws2812 every "..DimTimer4.." ms over a time period of "..Fadetime1.." ms.\r\n")


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
              end) --end timer0 function


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
              end) --end timer1 function


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
              end) --end timer2 function


              tmr.alarm(3, (DimTimer4), 1, function() 
                    mycounter = mycounter+DimTimer4
                    buffer:fill(LED1_G_current, LED1_R_current, LED1_B_current)
                    ws2812.write(buffer)
                    --print(LED1_R_current..","..LED1_G_current..","..LED1_B_current.."\r")
                    if mycounter > Fadetime1 then
                      mycounter=0
                      print("\r\nFinal color: "..LED1_R_current..","..LED1_G_current..","..LED1_B_current.."\n")
                      tmr.stop(3)
                      
                    end
                    
              end) --end timer3 function




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
