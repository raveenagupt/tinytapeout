module RangeFinder
    #(parameter WIDTH=16)
    (input logic [WIDTH-1:0] data_in,
    input logic clock,reset,
    input logic go, finish,
    output logic [WIDTH-1:0] range,
    output logic debug_error);


    parameter idle_state = 0, go_state = 1, reading_state = 2, error_state = 3, finish_state = 4;
    logic [2:0] state;
    logic [WIDTH-1:0] minimum;
  	logic [WIDTH-1:0] maximum;

  always_ff @(posedge clock) begin 
        if (reset) begin
            state <= idle_state;
            minimum <= 0;
            maximum <= 0;
          	debug_error <= 0;
        end 

        else begin

        case(state) 
            (idle_state): begin
                if(finish && go) begin 
                    state <= error_state;
                    debug_error <= 1;

                end
              
                else if(go) begin
                    minimum <= data_in;
                    maximum <= data_in;
                    state <= reading_state;
                end 
                else if(finish) begin
                    state <= error_state;
              
                    debug_error <= 1;

                end

                else begin
                    state <= idle_state;
                    minimum <= 0;
                    maximum <= 0;
                  
                end

            end
            (reading_state): begin
              	debug_error <= 0;
                if(finish) begin
                    minimum <= (data_in < minimum) ? data_in : minimum;
                    maximum <= (data_in > maximum) ? data_in : maximum;
                    range <= maximum - minimum;
                    state <= finish_state;
                end
                else if(finish && go) begin 
                    state <= error_state;
                  	debug_error <= 1;
                end
                else begin
                    minimum <= (data_in < minimum) ? data_in : minimum;
                    maximum <= (data_in > maximum) ? data_in : maximum;
                    state <= reading_state;                 
                end

            end
            (finish_state): begin
                minimum <= (data_in < minimum) ? data_in : minimum;
                maximum <= (data_in > maximum) ? data_in : maximum;
                range <= maximum - minimum;

                if(finish && go) begin 
                    state <= error_state;
                    debug_error <= 1;


                end
                else if(finish) begin
                    state <= finish_state;
                end 
                else if(go) begin
                    minimum <= 0;
                    maximum <= 0;
                    state <= reading_state;
                end
                else begin
                    state <= idle_state;
                end 
            end
            
            (error_state): begin
                debug_error <= 1;
                if(finish && go) begin 
                        state <= error_state;
                end
                else if(go) begin
                  	debug_error <= 0;
                    state <= reading_state;
                    minimum <= 0;
                    maximum <= 0;

                end 
                else begin
                    state <= error_state;
                end 

            end 


            
            
        
        endcase
        
        
        end


    end 
    endmodule

    







