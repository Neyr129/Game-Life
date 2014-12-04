    function next() {
        $.ajax({
            type: "GET",
            url: "/next",
            success: function(get_str){
                refresh_field(get_str)      
            }
        }); 
        $.ajax({
            type: "GET",
            url: "/inc_step",
            success: function(step){
                $("#count").text("step: "+ step)
            }
        });
    };

    function previous() {
        $.ajax({
            type: "GET",
            url: "/previous",
            success: function(get_str){
                refresh_field(get_str)      
            }
        });  
        $.ajax({
            type: "GET",
            url: "/dec_step",
            success: function(step){
                $("#count").text("step: "+ step)
            }
        });
    };

    function kill(id) {
        $('#'+id).attr("onmousedown", "live("+id+")");
        $('#'+id).attr("class", "dead");
        $.ajax({
            type: "POST",
            url: "/kill",
            data: {index: id},
            success: function(condition){
            }
        }); 
        $.ajax({
            type: "GET",
            url: "/inc_step",
            success: function(step){
                $("#count").text("step: "+ step)
            }
        });
    };    

    function live(id) {
        $('#'+id).attr("onmousedown", "kill("+id+")");
        $('#'+id).attr("class", "alive");
        $.ajax({
            type: "POST",
            url: "/live",
            data: {index: id},
            success: function(condition){
            }
        }); 
        $.ajax({
            type: "GET",
            url: "/inc_step",
            success: function(step){
                $("#count").text("step: "+ step)
            }
        });
    };

    function refresh_field(temp_str){
        for( i=0; i < (temp_str.length); i++){
            if (temp_str[i] == '*') {
                $('#'+i).attr("onmousedown", "kill("+i+")")
                $("#"+i).attr("class", "alive");
            }
            else if (temp_str[i] == ' ') {
                $('#'+i).attr("onmousedown", "live("+i+")")
                $("#"+i).attr("class", "dead");
            }
        } 
    };
