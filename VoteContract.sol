pragma solidity ^0.4.0;
contract voteDemo {
    
    //����ͶƱ�˵Ľṹ
    struct Voter{
        uint weight;//ͶƱ�˵�Ȩ��
        bool voted;//�Ƿ��Ѿ�Ͷ��Ʊ
        address delegate;//ί�д�����ͶƱ
        uint vote;//ͶƱ��������

    }
    
    //����ͶƱ����Ľṹ
    struct Posposal{
        bytes8 name; //����
        uint voteCount;//Ʊ��
    }
    
    //����ͶƱ������
    address public chairperson;
    
    //�����˵�ͶƱ��
    mapping(address => Voter) public voters;
    
    //�����ͶƱ����
    Posposal[] public posposals;
    
    //���캯��
    function  votedemo(bytes8[] peposposalName)
    public
    {
        //��ʼͶƱ�ķ����ˣ�����Լ�Ĳ�����
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        
        //��ʼ��ͶƱ������
        for(uint i =0; i < peposposalName.length; i++)
        {
            posposals.push(Posposal({name:peposposalName[i],voteCount:0}));
        }
    }
        
        //���ͶƱ����
        function giveRightToVote(address _voter)
        public
        {
            //ֻ��ͶƱ�ķ����˲ſ������ͶƱ��
            require(msg.sender == chairperson || !voters[_voter].voted );
            
            //����ϸ��ͶƱ�˵�ͶƱȨ��
            voters[_voter].weight = 1;
        }
        
        //ί�����˰��Լ�ͶƱ
        function delegate(address to)
        public
        {
            //��鵱ǰ���׵ķ������Ƿ�Ͷ��Ʊ
            Voter storage sender = voters[msg.sender];
            require(!sender.voted);
            
            //���ί�����ǲ���Ҳί�������˰���ͶƱ
            while(voters[to].delegate != address(0))
            {
                //ί���˵�ί���˲������Լ�
                to = voters[to].delegate;
                require(to != msg.sender);
            }
            
            //���׷����˲�����ͶƱȨ��
            sender.voted = true;
            //���ý��׷����˵�ͶƱί����
            sender.delegate = to;
            
            //�ҵ�������
            Voter storage delegate1 = voters[to];
            
            //���������Ƿ�Ͷ��Ʊ
            if(delegate1.voted){
                //����ǣ����Ʊֱ��Ͷ��������Ͷ���Ǹ�����
                posposals[delegate1.vote].voteCount += sender.weight;
            }
            else{
                //������ǣ����ͶƱ��Ȩ�ظ�������
                delegate1.weight += sender.weight; 
            }
        }
        
        //ͶƱ
        function vote(uint pid)
        public
        {
        //�ҵ�ͶƱ��
         Voter storage sender = voters[msg.sender];
         //����Ƿ�Ͷ��Ʊ
         require(!sender.voted);
             sender.voted = true; //���õ�ǰ�û��Ѿ�ͶƱ
             sender.vote = pid; //���õ�ǰ�û�ͶƱ����
             posposals[pid].voteCount +=sender.weight; //��Ȩ�ظ�����赱ǰ����
        }
        
        //����Ʊ����������
        function Winid() public
        constant returns(uint Winningpid)
        {
            uint WinningCount = 0;
            //�������ҵ�Ʊ�������������
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
