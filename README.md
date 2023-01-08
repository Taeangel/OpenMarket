# OpenMarket

- throbleShooting

1. memory leak 
detailview으로 화면전환하고 화면에서 나가도 메모리에서 지워지지 않는 문제가 있었습니다 [weak self]를 사용해 문제를해결 했습니다.
2. 의존성 주입 
기존 방식대로 맨위서부터 차례대로 의존성을 주입해 가장 하단에 있는 뷰까지 도달하려다 보니까 유지보수에 자원이 많이 들어갔었습니다. 팩토리 패턴으로 문제를 해결했습니다.
3. coredata 시점문제
코어데이터를 활용하여 좋아하는 상품 기능을 만들었습니다 그러나 coredata Service 와 바로 바인딩을 해주었더니 coredata에 있는 정보를 바로 업데이트를 하지 않는 문제가있어 시간을 살짝 걸어주는 걸로 해결했습니다.
4.flatMap 강제업래핑
Empty(completeImmediately: true).eraseToAnyPublisher() 으로 처리
5.unittest 오염성
유닛 테스트를 진행 하다 보니까 실제 서버에 테스트용 상품이 올라가서 테스트 한번하고 실제 프로젝트를 실행시켜 지우고를 반복하다 예전에 mockTest를 했었던 것이 기억이나 mock test 를 진행하기위해 기존의 싱글톤 코드를 리팩하여 의존성 주입을 하도록 변경 하여 성공과 실패 실제 Session을 주입하도록 변경 하여 유닛테스트의 오염성 문제를 해결하였습니다.
6.URLRequestManager
URLRequset를 enum으로 만들어 편하게 사용하도록 구조를 설계 하였습니다.
7.ProductNetworkService의 기능 비대
프로토콜 확장을 통하여 기능별로 분리하였습니다.
8. 수정화면과 추가화면의 같은기능
프로토콜의 기본구현으로 문제를 해결하려 하였으나 observerableObject를 채택하려면 class를 사용해야하고 완전히 같은 기능을 사용해야 하므로 상속으로 중복코드 문제를 해결하였습니다.
