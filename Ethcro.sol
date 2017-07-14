pragma solidity ^0.4.13;

contract Ethcro {
    struct Arbiter{
        address arbiter;
        string avatar;
        string specialty;
        string profile;
        uint karma;
        uint exp;
    }
    struct Contract {
        string desc; 
        Proof creator_pow;
        Proof signer_pow;
        uint value;  
        address arbiter; 
        bool is_arbiter;
        address creator;
        address signer;
        bool creator_signed;
        bool signer_signed;
        bool arbitration_ended;
        bool creator_completed;
        bool signer_completed;
        bool dispersed;
        bool is_dispute;
        Conversation[] dispute;
        Resolution resolution;
        uint creator_rating;
        uint signer_rating; 
        bool _public;       
    }
    struct Conversation{
        string text;
        address author;
        uint time;
    }   
    struct Person{
        address addr;
        string avatar;
        string profile;
        uint exp ;
        uint time;
        uint rating;
        uint rating_count;
    }    
    struct Proof{
        string format;
        string value;
        uint time;
    }
    struct Resolution{
        address winner;
        address loser;
        string reason;
        uint winning_percent;
        uint losing_percent;
        uint time;
    }    
    address Owner;
    address Supreme_Arbiter;
    uint Contract_Id;
    uint fee;
    address[] Arbiter_Array;
    address[] People_Array;
    uint[] Public;
    mapping(address => Arbiter) Arbiters;
    mapping(uint => Contract) Contracts;
    mapping(address => Person) People;
    mapping(address => uint[]) Read;
    mapping(address => uint[]) Written;
    function Ethcro()payable
        {
            Owner = msg.sender;
            Supreme_Arbiter = msg.sender;
            fee = 999;
            Arbiters[msg.sender] = Arbiter({karma:msg.value,avatar:"http://goo.gl/WFHDTL",specialty:"Contract Management",profile:"Yo dawg, I heard you like Contracts",exp:999,arbiter:msg.sender});
			Arbiter_Array.push(msg.sender);
        }
    function (){revert();}
    function add_arbiter(string ind,string img, string info) payable
        {
            if(msg.value < fee)revert();
            if(Arbiters[msg.sender].arbiter != msg.sender)
                {
                    Arbiter_Array.push(msg.sender);
                }
            Arbiters[msg.sender] = Arbiter({karma:Arbiters[msg.sender].karma,avatar:img,profile:info,specialty:ind,exp:Arbiters[msg.sender].exp,arbiter:msg.sender});
        }
    function add_person(string img, string info) payable
        {
            if(msg.value < fee)revert();
            if(People[msg.sender].addr != msg.sender)
                {
                    People_Array.push(msg.sender);
                }
            People[msg.sender] = Person({rating_count:People[msg.sender].rating_count,addr:msg.sender,rating:People[msg.sender].rating,avatar:img,profile:info,exp:People[msg.sender].exp,time:block.number});
        }        
	function check_arbiter_1_2(address id) constant returns (uint exp,uint karma,string avatar,string profile)
	   {
	        return (Arbiters[id].exp,Arbiters[id].karma,Arbiters[id].avatar,Arbiters[id].profile);
	   } 
	function check_arbiter_2_2(address id) constant returns (address addr,string speciality)
	   {
	        return (Arbiters[id].arbiter,Arbiters[id].specialty);
	   } 	   
	function check_contracts_owned() constant returns(uint[] written,uint[] read, uint[] public_contracts)
		{
		    return (Written[msg.sender],Read[msg.sender],Public);
		}
	function check_contract_1(uint id) constant returns (string description,string creator_pow,string signer_pow,uint value,address arbiter,address creator,address signer)
	    {
	        if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender && Contracts[id]._public == false) revert();
	        return (Contracts[id].desc,Contracts[id].creator_pow.value,Contracts[id].signer_pow.value,Contracts[id].value,Contracts[id].arbiter,Contracts[id].creator,Contracts[id].signer);
	    }
	function check_contract_2(uint id) constant returns (bool creator_signed,bool signer_signed,bool is_arbiter,bool arbitration_ended,uint creator_rating,uint signer_rating)
	    {
	        if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender && Contracts[id]._public == false) revert();
	        return (Contracts[id].creator_signed,Contracts[id].signer_signed,Contracts[id].is_arbiter,Contracts[id].arbitration_ended,Contracts[id].creator_rating,Contracts[id].signer_rating);
	    }
	function check_contract_3(uint id) constant returns (bool creator_completed,bool signer_completed,bool is_dispute,bool dispersed,uint dispute_legnth,uint creator_pow_time,uint signer_pow_time)
	    {
	        if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender && Contracts[id]._public == false) revert();
	        return (Contracts[id].creator_completed,Contracts[id].signer_completed,Contracts[id].is_dispute,Contracts[id].dispersed,Contracts[id].dispute.length,Contracts[id].creator_pow.time,Contracts[id].signer_pow.time);
	    }
	function check_contract_4(uint id) constant returns (address winner, address loser, string reason, uint winning_percent,uint losing_percent,uint time)
	    {
	        if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender && Contracts[id]._public == false) revert();
	        return (Contracts[id].resolution.winner,Contracts[id].resolution.loser,Contracts[id].resolution.reason,Contracts[id].resolution.winning_percent,Contracts[id].resolution.losing_percent,Contracts[id].resolution.time);
	    }
    function complete_contract(uint id,string proof,string ftype)
        {
            if(Contracts[id].dispersed == true || Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender) revert();
		    if(Contracts[id].creator == msg.sender)
		        {
		            Contracts[id].creator_completed = true;
		            Contracts[id].creator_pow = Proof({format:ftype,value:proof,time:block.number});	
		        }
		    if(Contracts[id].signer == msg.sender)
		        {
		            Contracts[id].signer_completed = true;
                    Contracts[id].signer_pow = Proof({format:ftype,value:proof,time:block.number});		            
		        }          
        }	 
    function create_contract(string info,address signer,int arbiter_choice,address optional_arbiter,int privacy) payable
        {
            if(msg.sender == optional_arbiter || msg.sender == signer) revert();
            Contracts[block.number].desc = info;
            Contracts[block.number].value = msg.value;
            if(arbiter_choice == 0){Contracts[block.number].is_arbiter = true;Contracts[block.number].arbiter = Supreme_Arbiter;Read[Supreme_Arbiter].push(block.number);}
            if(arbiter_choice == 1)
				{
					if(Arbiters[optional_arbiter].arbiter != optional_arbiter)revert();
					Contracts[block.number].is_arbiter = true;
					Read[optional_arbiter].push(block.number);
					Contracts[block.number].arbiter = optional_arbiter;
				}
            Contracts[block.number].desc = info;
            Contracts[block.number].creator = msg.sender;
            Written[msg.sender].push(block.number); 
            if(privacy == 0)
				{
					Contracts[block.number]._public = false;
					Contracts[block.number].signer = signer;
					Read[signer].push(block.number);
				}
            else
				{
					if(!Contracts[block.number].is_arbiter)revert();
					Contracts[block.number]._public = true;
					Public.push(block.number);
				}            
        }        
    function dispute(uint id,string disp)
        {
            if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender)revert();
            if(Contracts[id].dispersed == true)revert();
            if(Contracts[id].is_arbiter != true)revert();
            if(!Contracts[id].is_dispute){Contracts[id].is_dispute = true;}
            Contracts[id].dispute.push(Conversation({text:disp,author:msg.sender,time:block.number}));
        }	    
	function get_arbiter() constant returns (address addr,string avatar, string profile,string specialty,uint exp,uint karma)
	    {
	        return (Arbiters[Supreme_Arbiter].arbiter,Arbiters[Supreme_Arbiter].avatar,Arbiters[Supreme_Arbiter].profile,Arbiters[Supreme_Arbiter].specialty,Arbiters[Supreme_Arbiter].exp,Arbiters[Supreme_Arbiter].karma);
	    }	
	function get_all_arbiters() constant returns (address[] arbiters)
	    {
            return Arbiter_Array;
	    }		    
	function get_all_people() constant returns(address[] people)
	    {
	        return People_Array;
	    }
	function get_person(address id) constant returns (uint rating_count,uint rating, string avatar, string profile, uint exp)
		{
			return (People[id].rating_count,People[id].rating,People[id].avatar,People[id].profile,People[id].exp);		
		}
	function join_contract(uint id)
	    {
	       if(Contracts[id].creator == msg.sender || Contracts[id].arbiter == msg.sender || Contracts[id]._public == false) revert();
	       Contracts[id]._public = false;
	       Contracts[id].signer = msg.sender;
	       Read[msg.sender].push(id);
	    }		
	function kill_contract(uint id)
	    {
	       if(Contracts[id].creator != msg.sender || Contracts[id].signer_signed == true || Contracts[id].dispersed == true) revert();
	       Contracts[id].dispersed = true;
	       Contracts[id].creator_pow.value = "Contract KILLED!";
	       msg.sender.transfer(Contracts[id].value);
	    }
	function rating(uint id,address user,uint star)
	    {
	        if(Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender)revert();
	        if(Contracts[id].signer != user && Contracts[id].creator != user)revert();
	        if(star < 1 || star > 5 || msg.sender == user || !Contracts[id].dispersed)revert();
	        if(msg.sender == Contracts[id].creator)
	            {
	                if(Contracts[id].signer_rating > 0)revert();
					else
						{
							Contracts[id].signer_rating = star;
						}
	            }
	        if(msg.sender == Contracts[id].signer)
	            {
	                if(Contracts[id].creator_rating > 0)revert();
	                else
						{
							Contracts[id].creator_rating = star;
						}
	            }	 
	        People[user].rating_count++;
			People[user].rating += star;
			People[user].exp++;               
	    }
	function resolve(uint id,address winner,address loser,uint winning_percent,uint losing_percent,string reason)
	    {
	        if(Contracts[id].arbiter != msg.sender || Contracts[id].dispersed == true || Contracts[id].arbitration_ended == true || !Contracts[id].is_dispute) revert();
            if((winning_percent + losing_percent) > 95)revert();
            if(winning_percent < losing_percent)revert();
            Contracts[id].arbitration_ended = true;
            Contracts[id].resolution.winner = winner;
            Contracts[id].resolution.loser = loser;
            Contracts[id].resolution.winning_percent = winning_percent;
            Contracts[id].resolution.losing_percent = losing_percent;
            Contracts[id].resolution.time = block.number;
            Contracts[id].resolution.reason = reason;
	    }
    function retract(uint id)
        {
            if(Contracts[id].creator != msg.sender || Contracts[id].signer_signed == true || Contracts[id].dispersed == true) revert();
            Contracts[id].dispersed = true;
            Contracts[id].creator.transfer(Contracts[id].value);
        }    
	function sign(uint id)
		{
            if(Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender && Contracts[id].arbiter != msg.sender)revert();
            if(Contracts[id].dispersed == true)revert();
		    if(Contracts[id].creator == msg.sender){Contracts[id].creator_signed = true;}
		    if(Contracts[id].signer == msg.sender){Contracts[id].signer_signed = true;}
		}	    
	 function withdraw_karma(uint amount)
	    {
	        if(Arbiters[msg.sender].karma < amount)
	            revert();
	       Arbiters[msg.sender].karma -= amount;
	       Arbiters[msg.sender].arbiter.transfer(amount);
	       if(Supreme_Arbiter == msg.sender)
	        {
	            if(Arbiters[msg.sender].karma < Arbiters[Owner].karma)
	                {
	                    Supreme_Arbiter = Owner;
	                }
	        }
	    }
	 function withdraw_from_contract(uint id)
	    {
	        if(Contracts[id].dispersed == true) revert();
		    if(!Contracts[id].is_arbiter)
		        {
		            if(Contracts[id].creator_signed && Contracts[id].signer_signed && Contracts[id].creator_completed && Contracts[id].signer_completed)
		                {
		                    Contracts[id].dispersed = true;
		                    Contracts[id].signer.transfer((Contracts[id].value * 995)/1000);
		                    Owner.transfer((Contracts[id].value * 5)/1000);
		                }
		        }
		    else
		        {
		            if(Contracts[id].is_dispute && !Contracts[id].arbitration_ended)revert();
		            if(!Contracts[id].is_dispute && Contracts[id].creator_signed &&  Contracts[id].signer_signed && Contracts[id].creator_completed && Contracts[id].signer_completed)
		                {
		                    Contracts[id].dispersed = true;
		                    Contracts[id].signer.transfer((Contracts[id].value * 99)/100);
		                    Arbiters[Contracts[id].arbiter].karma =  Arbiters[Contracts[id].arbiter].karma + (Contracts[id].value * 1)/100;
		                }
		            if(Contracts[id].is_dispute && Contracts[id].arbitration_ended &&(Contracts[id].creator == Contracts[id].resolution.winner || Contracts[id].resolution.winner == Contracts[id].signer) )
		                {
		                    if((Contracts[id].resolution.winning_percent + Contracts[id].resolution.losing_percent) > 95)revert();
		                    Arbiters[Contracts[id].arbiter].exp++;
		                    Contracts[id].dispersed = true;
		                    Contracts[id].resolution.winner.transfer((Contracts[id].value *  Contracts[id].resolution.winning_percent)/100);
		                    Contracts[id].resolution.loser.transfer((Contracts[id].value *  Contracts[id].resolution.losing_percent)/100);
		                    Arbiters[Contracts[id].arbiter].karma =  Arbiters[Contracts[id].arbiter].karma + (Contracts[id].value * 4)/100;
		                }
		            Arbiters[Contracts[id].arbiter].exp++;
		            if(Arbiters[Contracts[id].arbiter].karma > Arbiters[Supreme_Arbiter].karma)
		                {
		                    if(Supreme_Arbiter != Arbiters[Contracts[id].arbiter].arbiter){Supreme_Arbiter = Arbiters[Contracts[id].arbiter].arbiter;}
		                }
		        }
	       
	    }
	 function update_fee(uint new_fee) payable
	    {
	        if(msg.sender != Owner)revert();
	        fee = new_fee;
	    }
	 function view_dispute_text(uint id,uint idt) constant returns(uint time,address author,string text)
	    {
	       if(Contracts[id].arbiter != msg.sender && Contracts[id].signer != msg.sender && Contracts[id].creator != msg.sender) revert();
            return (Contracts[id].dispute[idt].time,Contracts[id].dispute[idt].author,Contracts[id].dispute[idt].text);
	    }
}
