pragma solidity ^0.4.0;
contract voteDemo {
    
    //定义投票人的结构
    struct Voter{
        uint weight;//投票人的权重
        bool voted;//是否已经投过票
        address delegate;//委托代理人投票
        uint vote;//投票主题的序号

    }
    
    //定义投票主题的结构
    struct Posposal{
        bytes8 name; //名字
        uint voteCount;//票数
    }
    
    //定义投票发起者
    address public chairperson;
    
    //所有人的投票人
    mapping(address => Voter) public voters;
    
    //具体的投票主题
    Posposal[] public posposals;
    
    //构造函数
    function  votedemo(bytes8[] peposposalName)
    public
    {
        //初始投票的发起人，即合约的部署人
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        
        //初始化投票的主题
        for(uint i =0; i < peposposalName.length; i++)
        {
            posposals.push(Posposal({name:peposposalName[i],voteCount:0}));
        }
    }
        
        //添加投票的人
        function giveRightToVote(address _voter)
        public
        {
            //只有投票的发起人才可以添加投票人
            require(msg.sender == chairperson || !voters[_voter].voted );
            
            //赋予合格的投票人的投票权重
            voters[_voter].weight = 1;
        }
        
        //委托他人帮自己投票
        function delegate(address to)
        public
        {
            //检查当前交易的发起者是否投过票
            Voter storage sender = voters[msg.sender];
            require(!sender.voted);
            
            //检查委托人是不是也委托其他人帮他投票
            while(voters[to].delegate != address(0))
            {
                //委托人的委托人不能是自己
                to = voters[to].delegate;
                require(to != msg.sender);
            }
            
            //交易发起人不再有投票权利
            sender.voted = true;
            //设置交易发起人的投票委托人
            sender.delegate = to;
            
            //找到代理人
            Voter storage delegate1 = voters[to];
            
            //检查代理人是否投过票
            if(delegate1.voted){
                //如果是，则把票直接投给代理人投的那个主题
                posposals[delegate1.vote].voteCount += sender.weight;
            }
            else{
                //如果不是，则把投票的权重给代理人
                delegate1.weight += sender.weight; 
            }
        }
        
        //投票
        function vote(uint pid)
        public
        {
        //找到投票人
         Voter storage sender = voters[msg.sender];
         //检查是否投过票
         require(!sender.voted);
             sender.voted = true; //设置当前用户已经投票
             sender.vote = pid; //设置当前用户投票主题
             posposals[pid].voteCount +=sender.weight; //把权重给与给予当前主题
        }
        
        //计算票数最多的主题
        function Winid() public
        constant returns(uint Winningpid)
        {
            uint WinningCount = 0;
            //遍历，找到票数最大的主题序号
            for(uint i = 0;i<posposals.length;i++){
                if(posposals[i].voteCount > WinningCount)
                {
                    WinningCount = posposals[i].voteCount;
                    Winningpid = i;
                }
            }
        }
        
        function winname() public
        constant returns(bytes8 winnername)
        {
            winnername = posposals[Winid()].name;
        }
        
    }
