class ahb2apb_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(ahb2apb_scoreboard);

	uvm_tlm_analysis_fifo#(write_xtn) wr_fifo;

	uvm_tlm_analysis_fifo#(read_xtn) rd_fifo[];

	ahb2apb_env_config env_cfg;
	
	int data_verified_count;

	int add_matched;

	int add_mismatch;

	int data_matched;
	
	int data_mismatch;

	write_xtn wr_xtn;
	
	read_xtn rd_xtn;

	read_xtn apb_cov_data; //read_cov

	write_xtn ahb_cov_data; //write_cov

	write_xtn q[$]; //queue to push data from AHB to compare it with APB 

covergroup ahb_cg;
		option.per_instance = 1;

		//RST: coverpoint ahb_cov_data.Hresetn;
		
		SIZE: coverpoint ahb_cov_data.Hsize {bins b2[] = {[0:2]} ;}//1,2,4 bytes of data
		
		TRANS: coverpoint ahb_cov_data.Htrans {bins trans[] = {[2:3]} ;}//NS and S
		
		//BURST: coverpoint ahb_cov_data.Hburst {bins burst[] = {[0:7]} ;}
		
		ADDR: coverpoint ahb_cov_data.Haddr {bins f1 = {[32'h8000_0000:32'h8000_03ff]} ;
						     bins f2 = {[32'h8400_0000:32'h8400_03ff]};
                                                     bins f3 = {[32'h8800_0000:32'h8800_03ff]};
                                                     bins f4 = {[32'h8C00_0000:32'h8C00_03ff]};}

		DATA_IN: coverpoint ahb_cov_data.Hwdata {bins low = {[0:32'h0000_ffff]};
                                                         bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}

                DATA_OUT : coverpoint ahb_cov_data.Hrdata {bins low = {[0:32'h0000_ffff]};
                                                           bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}
		WRITE : coverpoint ahb_cov_data.Hwrite;

		SIZEXWRITE: cross SIZE, WRITE;
	endgroup: ahb_cg

	covergroup apb_cg;
		option.per_instance = 1;
		
		ADDR : coverpoint apb_cov_data.Paddr {bins s1 = {[32'h8000_0000:32'h8000_03ff]};
                                                      bins s2 = {[32'h8400_0000:32'h8400_03ff]};
                                                      bins s3 = {[32'h8800_0000:32'h8800_03ff]};
                                                      bins s4 = {[32'h8C00_0000:32'h8C00_03ff]};}
				
		DATA_IN : coverpoint apb_cov_data.Pwdata {bins low = {[0:32'h0000_ffff]};
                                                          bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}

                DATA_OUT : coverpoint apb_cov_data.Prdata {bins low = {[0:32'hffff_ffff]};}

                WRITE : coverpoint apb_cov_data.Pwrite;

	endgroup: apb_cg



	extern function new(string name="ahb2apb_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

	extern task check_data(write_xtn wr_xtn, read_xtn rd_xtn);

//	extern task check_data(read_xtn rd_xtn);

	extern task compare_data( bit[31:0]Haddr,bit[31:0] Paddr, bit[31:0]Hdata, bit[31:0]Pdata);
	
	extern function void report_phase(uvm_phase phase);
endclass

function ahb2apb_scoreboard::new(string name="ahb2apb_scoreboard",uvm_component parent);
	super.new(name,parent);
	apb_cg=new();
	ahb_cg=new();
endfunction

function void ahb2apb_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this,"","ahb2apb_env_config",env_cfg))
		`uvm_fatal("SB","cannot get the config data");
	rd_fifo=new[env_cfg.no_of_slave_agents];
	wr_fifo=new("wr_fifo",this);
	foreach(rd_fifo[i])
		rd_fifo[i]=new($sformatf("rd_fifo[%0d]",i),this);
	super.build_phase(phase);
endfunction

task ahb2apb_scoreboard::run_phase(uvm_phase phase);

/*if (rd_xtn == null) begin
        `uvm_error("SB", "rd_xtn is null inside run_phase");
        return;
    end
else
	$display("rd_xtn is fine ");*/
	fork 
		begin
			forever
				begin
				wr_fifo.get(wr_xtn);
				rd_fifo[0].get(rd_xtn);
				q.push_back(wr_xtn);
				$display("Size of the queue = %d",q.size);
				ahb_cov_data=wr_xtn;//cov
				ahb_cg.sample();//cov
			//	rd_xtn.print();
				check_data(wr_xtn,rd_xtn);
				apb_cov_data=rd_xtn;//cov
				apb_cg.sample();//cov
				end
		end
	
	join
	
endtask


task  ahb2apb_scoreboard::check_data(write_xtn wr_xtn, read_xtn rd_xtn);

wr_xtn=q.pop_front();

/*if (wr_xtn == null) begin
        `uvm_error("SB", "wr_xtn is null");
        return;
    end
*/
if(wr_xtn.Hwrite)
begin
	case(wr_xtn.Hsize)
	
	2'b00:
		begin
		if(wr_xtn.Haddr[1:0]==2'b00)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[7:0], rd_xtn.Pwdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b01)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[15:8], rd_xtn.Pwdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b10)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[23:16], rd_xtn.Pwdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b11)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[31:24], rd_xtn.Pwdata[7:0]);
		end

	
	2'b01:
		begin
		if(wr_xtn.Haddr[1:0]==2'b00)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[15:0], rd_xtn.Pwdata[15:0]);

		if(wr_xtn.Haddr[1:0]==2'b10)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata[31:16], rd_xtn.Pwdata[15:0]);
		end

	
	2'b10:
		begin
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hwdata, rd_xtn.Pwdata);
		end
	endcase
end
	
else
	begin
		
	case(wr_xtn.Hsize)
	
	2'b00:
		begin
		if(wr_xtn.Haddr[1:0]==2'b00)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[7:0], rd_xtn.Prdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b01)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[15:8], rd_xtn.Prdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b10)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[23:16], rd_xtn.Prdata[7:0]);
		if(wr_xtn.Haddr[1:0]==2'b11)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[31:24], rd_xtn.Prdata[7:0]);
		end

	
	2'b01:
		begin
		if(wr_xtn.Haddr[1:0]==2'b00)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[15:0], rd_xtn.Prdata[15:0]);

		if(wr_xtn.Haddr[1:0]==2'b10)
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata[31:16], rd_xtn.Prdata[15:0]);
		end
	
	2'b10:
		begin
			compare_data(wr_xtn.Haddr, rd_xtn.Paddr, wr_xtn.Hrdata, rd_xtn.Prdata);
		end
	endcase
	end
	
endtask
		
task  ahb2apb_scoreboard::compare_data( bit[31:0]Haddr,bit[31:0] Paddr, bit[31:0]Hdata, bit[31:0]Pdata);

	if(Haddr==Paddr)
		begin
		$display("Address compared_successfully");
		$display("HADDR=%h, PADDR=%h", Haddr, Paddr);
		//add_matched++;
		end
	else
		begin
		$display("Address mismatch found");
		$display("HADDR=%h, PADDR=%h", Haddr, Paddr);
		//add_mismatch++;
		end

	if(Hdata==Pdata)
		begin
		$display("Data compared_successfully");
		$display("HDATA=%h, PDATA=%h", Hdata, Pdata);
		//data_matched++;
		end
	else
		begin
		$display("Data mismatch found");
		$display("HDATA=%h, PDATA=%h", Hdata, Pdata);
		//data_mismatch++;
		end
	data_verified_count++;
endtask


function void ahb2apb_scoreboard::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report:Router Scoreboard compared %0d transactions", data_verified_count), UVM_LOW)
	$display("address_matched_count=%0d",add_matched);
	$display("data_matched_count=%0d",data_matched);
	$display("address_mismatch_count=%0d",add_mismatch);
	$display("data_mismatch_count=%0d",data_mismatch);
endfunction








