pragma solidity >=0.4.18 <=0.8;
 
contract Voting {
    
    //投票者ストラクト
    struct Voter{  
        bool voted; //投票したかどうか trueなら投票済 初期値はfalse
        uint weight; //投票の重み 初期値は0
    }
    
    //投票者マッピング
    mapping(address => Voter) public voters;
    
    //議長
    address public chairperson;
    
    //候補者リスト
    string [] public candidateList;
    
    //候補者名と得票数
    mapping (string => uint) public votesReceived;
    
    //コンストラクタ
    function Vote(string memory _candidateNames) public {
        chairperson = msg.sender; //議長を設定
        candidateList.push(_candidateNames); //候補者名を登録
    }

    //候補者リストを取得
    function getCandidateList() public view returns(string[] memory) {
        return candidateList;
    }
    
    
    //議長が投票者に投票権を与える
    function giveRightToVote(address _voter) public payable {
        //議長であることかつ投票者が未投票であること
        require((msg.sender == chairperson) && !voters[_voter].voted);//true == !false
        voters[_voter].weight = 1;
    }
    
    //候補者名を記述して投票する
    function voteForCandidate(string memory _candidate) payable public {
        require(validCandidate(_candidate)); //正しい候補者名が入力されたか
        
        Voter storage sender = voters[msg.sender];
        require((sender.weight>0) && !sender.voted); //投票権を持ちかつ未投票であること
        
        votesReceived[_candidate] += sender.weight;
        sender.voted = true; //投票完了
    }
    
    //候補者の得票数を知る
    function totalVotesFor(string memory _candidate) view public returns (uint) {
        require(validCandidate(_candidate));
        return votesReceived[_candidate];
    }
    
    //候補者名チェック
    function validCandidate(string memory _candidate) view public returns (bool) {
        for(uint i = 0; i < candidateList.length; i++) {
            require(keccak256(abi.encode(candidateList[i])) == keccak256(abi.encode(_candidate)));
            return true;            
        }
        return false;
    }
        
}
