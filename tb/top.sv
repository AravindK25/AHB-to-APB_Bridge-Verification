module top;

//import ram_test_pkg
	
	import ahb2apb_test_pkg::*;

//import uvm_pkg.sv
	import uvm_pkg::*;

//Generate clock signal
	bit clock;
	always
	#10 clock=!clock;

//Instantiate  ahb2apb_if interface instances with clock as input

	ahb_if master_if(clock);
	apb_if slave_if(clock);

	
rtl_top DUT(
            .Hclk(clock),
            .Hresetn(master_if.Hresetn),
            .Htrans(master_if.Htrans),
            .Hsize(master_if.Hsize),
            .Hreadyin(master_if.Hreadyin),
            .Hwdata(master_if.Hwdata),
            .Haddr(master_if.Haddr),
            .Hwrite(master_if.Hwrite),
            .Hrdata(master_if.Hrdata),
            .Hresp(master_if.Hresp),
            .Hreadyout(master_if.Hreadyout),
            .Pselx(slave_if.Pselx),
            .Pwrite(slave_if.Pwrite),
            .Penable(slave_if.Penable),
	    .Prdata(slave_if.Prdata),
            .Paddr(slave_if.Paddr),
	    .Pwdata(slave_if.Pwdata)
            ) ;	


//In initial block

	initial 
	begin
	
	//set the virtual interface instances as strings using the uvm_config_db
	uvm_config_db #(virtual ahb_if)::set(null,"*","master_vif_0",master_if);
	
	uvm_config_db #(virtual apb_if)::set(null,"*","slave_vif_0",slave_if);

	//call run_test

	run_test();
	end

endmodule
