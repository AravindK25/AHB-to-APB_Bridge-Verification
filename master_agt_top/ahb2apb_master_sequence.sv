class ahb2apb_mbase_seq extends uvm_sequence #(write_xtn);
	
	`uvm_object_utils(ahb2apb_mbase_seq)
	
	logic [31:0]haddr;
	logic hwrite;
	logic [2:0]hsize;
	logic [2:0]hburst;
	logic [9:0]hlength;

//standard UVM methods
	extern function new(string name= "ahb2apb_mbase_seq");
endclass

function ahb2apb_mbase_seq::new(string name= "ahb2apb_mbase_seq");
	super.new(name);
endfunction


//single transfer sequence

class ahb2apb_single_wr_xtns extends ahb2apb_mbase_seq;

	`uvm_object_utils(ahb2apb_single_wr_xtns)

extern function new(string name= "ahb2apb_single_wr_xtns");
extern task body();
endclass

function ahb2apb_single_wr_xtns::new(string name= "ahb2apb_single_wr_xtns");
	super.new(name);
endfunction

task ahb2apb_single_wr_xtns::body();

	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst==3'b000;
				   Hwrite==1;});
	finish_item(req);
endtask

//unspecified length sequence 

class ahb2apb_unspecified_wr_xtns extends ahb2apb_mbase_seq;

	`uvm_object_utils(ahb2apb_unspecified_wr_xtns)

extern function new(string name= "ahb2apb_unspecified_wr_xtns");
extern task body();
endclass

function ahb2apb_unspecified_wr_xtns::new(string name= "ahb2apb_unspecified_wr_xtns");
	super.new(name);
endfunction

task ahb2apb_unspecified_wr_xtns::body();

	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst==3'b001;
				   Hwrite==1;});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
	hlength = req.length;	
if(hburst==3'b001)
begin
for(int i=0;i<hlength;i++)
	begin	
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	else if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	else if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end
	
	finish_item(req);
	haddr=req.Haddr;
	end
end
endtask

//increment Burst operation with 1 byte,2 bytes and 4 bytes transfer sequence

class ahb2apb_inc_wr_xtns extends ahb2apb_mbase_seq;

	`uvm_object_utils(ahb2apb_inc_wr_xtns)

extern function new(string name= "ahb2apb_inc_wr_xtns");
extern task body();
endclass
function ahb2apb_inc_wr_xtns::new(string name= "ahb2apb_inc_wr_xtns");
	super.new(name);
endfunction

task ahb2apb_inc_wr_xtns::body();

	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   //Hsize==3'b000;//test
				   Hwrite==1'b1;//test
				   Hburst inside {3,5,7};});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

if(hburst==3'b011)//increment-4
begin
for(int i=0;i<3;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b101)//increment-8
begin
for(int i=0;i<7;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b111)//increment-16
begin
for(int i=0;i<15;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end

	start_item(req);
	assert(req.randomize with {Htrans==2'b00;});
	finish_item(req);

endtask



//wrapping burst operation 1byte,2byte & 4 bytes 
class ahb2apb_wrap_wr_xtns extends ahb2apb_mbase_seq;

	`uvm_object_utils(ahb2apb_wrap_wr_xtns)

extern function new(string name= "ahb2apb_wrap_wr_xtns");
extern task body();
endclass
function ahb2apb_wrap_wr_xtns::new(string name= "ahb2apb_wrap_wr_xtns");
	super.new(name);
endfunction

task ahb2apb_wrap_wr_xtns::body();

	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst inside {2,4,6};
				   //Hwrite==1;
					});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

if(hburst==3'b010)//wrap-4
begin
for(int i=0;i<3;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b100)//wrap-8
begin
for(int i=0;i<7;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b110)//wrap-16
begin
for(int i=0;i<15;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


	start_item(req);
	assert(req.randomize with {Htrans==2'b00;});
	finish_item(req);

endtask


