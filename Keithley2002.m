classdef Keithley2002 < handle
    %might have to initiate twice
    
%% Properties

properties (Constant)
    cIPadress = '192.168.1.111' % this is always the same
    cJARPath = './java-assets/jGpibEnet-1.0-all.jar'
end

properties
    gpibInterface % this holds the java instance of the gpib interface
end


properties (Access = private)

end



%%
methods
    %% Constructor
    function this = Keithley2002()
        this.init()
    end
    
    
    function init(this)
        javaaddpath(this.cJARPath)
        import cxro.common.io.jGpibEnet.GpibEnetDriver
        import cxro.common.io.jGpibEnet.GpibEnetException
        import cxro.common.io.jGpibEnet.controllers.ControllerType
        
        this.gpibInterface = GpibEnetDriver();
        this.gpibInterface.setControllerType(ControllerType.ICS8065);
        this.gpibInterface.setIpAddress(this.cIPadress);
        this.gpibInterface.openDevice(16, 1000);
        
        this.gpibInterface.write('*CLS');
        this.gpibInterface.write('*RST');

        this.gpibInterface.write('res:rang 10e-5')
        this.gpibInterface.write('func ''curr:dc''');
    end

    function val = read(this)
        this.gpibInterface.write(':read?')
        res = char(this.gpibInterface.read(256));
        
        val = str2double( regexp(res, '(^[-+]\d+\.\d+E[-+]\d\d)', 'match'));
    end

end

end
