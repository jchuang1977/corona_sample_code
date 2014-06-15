local thisDeviceHeight = 480
if(system.getInfo("model") == "iPhone") or (system.getInfo("model") == "iPod touch") then
    local isIPhone5 = (display.pixelHeight >960)
    if isIPhone5 then
        thisDeviceHeight = 568
    end
end

application =
{
    content =
    {
       width = 320,
       height = thisDeviceHeight,
       scale = "zoomStretch",
       fps = 30,
       antialias = true,      
       imageSuffix =
      	{
      		["@2x"] = 1.8,
      	},
    },
}