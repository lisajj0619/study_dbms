show databases;
use test;

create table tbl_member(
    memner_name varchar(255),
    member_age int
);

show tables;

drop table tbl_member;

/*
    자동차 테이블 생성
    1. 자동차 번호
    2. 자동차 브랜드
    3. 출시 날짜
    4. 색상
    5. 가격
*/

create table tbl_car(
    car_number bigint primary key,
    car_brand varchar(255),
    release_date date,
    car_color varchar(255),
    car_price int
);

drop table tbl_car;

/*
    동물 테이블 생성
    1. 번호
    2. 종류 (중복되지 않게)
    3. 먹이
*/

create table tbl_animals(
    number bigint primary key,
    type varchar(255) not null unique,
    feed varchar(255)
);

show tables;

drop table tbl_animals;


/*
    회원				주문				상품
	-----------------------------------------------------------------
	번호PK			번호PK			번호PK
	-----------------------------------------------------------------
	아이디U, NN		날짜NN			이름NN
	비밀번호NN		회원번호FK, NN	가격default = 0 (기본값)
	이름NN			상품번호FK, NN	재고default = 0 (기본값)
	주소NN
	이메일
	생일

*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_product(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0,
    stock int default 0
);

create table tbl_order(
    id bigint primary key,
    order_date datetime default current_timestamp,
    user_id bigint not null,
    product_id bigint not null,
    constraint fk_order_user foreign key(user_id)
    references tbl_user(id),
    constraint fk_order_product foreign key(product_id)
    references tbl_product(id)
);

drop table tbl_user, tbl_order, tbl_product;


/*
    1. 요구사항 분석
        꽃 테이블과 화분 테이블 2개가 필요하고,
        꽃을 구매할 때 화분도 같이 구매합니다.
        꽃은 이름과 색상, 가격이 있고,
        화분은 제품번호, 색상, 모양이 있습니다.
        화분은 모든 꽃을 담을 수 없고 정해진 꽃을 담아야 합니다.

    2. 개념 모델링
        꽃       화분
    ---------------------
        번호      번호
    ---------------------
        이름      제품번호
        색상      색상
        가격      모양

    3. 논리 모델링
        꽃           화분
    --------------------------------
        번호PK        제품번호PK
    --------------------------------
        이름U, NN     번호FK
        색상NN        색상NN
        가격D=0       모양NN

    4. 물리 모델링
    tbl_flower
    ------------------------
    id: bigint primary key
    ------------------------
    flower_name: varchar(255) unique not null
    flower_color: varchar(255) not null
    flower_price: int default 0

    tbl_flowerpot
    ------------------------
    id: bigint primary key
    ------------------------
    flower_id: bigint not null
    pot_color: varchar(255) not null
    pot_shape: varchar(255) not null

    5. 구현
*/

create table tbl_flower(
    id bigint primary key,
    flower_name varchar(255) unique not null,
    flower_color varchar(255) not null,
    flower_price int default 0
);

create table tbl_flowerpot(
    id bigint primary key,
    flower_id bigint not null,
    flowerpot_color varchar(255) not null,
    flowerpot_shape varchar(255) not null,
    constraint fk_flowerpot_flower foreign key(flower_id)
    references tbl_flower(id)
);

drop table tbl_flower, tbl_flowerpot;

/*
    복합키(조합키): 하나의 PK에 여러 컬럼을 설정한다.
*/
create table tbl_flower(
    name varchar(255) unique not null,
    color varchar(255) not null,
    flower_price int default 0,
    primary key(name, color)
);

create table tbl_flowerpot(
    id bigint primary key,
    color varchar(255) not null,
    shape varchar(255) not null,
    flower_name varchar(255) not null,
    flower_color varchar(255) not null,
    constraint fk_flowerpot_flower foreign key(flower_name, flower_color)
    references tbl_flower(name, color)
);

drop table tbl_flower, tbl_flowerpot;

/*
    1. 요구사항 분석
        안녕하세요, 동물병원을 곧 개원합니다.
        동물은 보호자랑 항상 같이 옵니다. 가끔 보호소에서 오는 동물도 있습니다.
        보호자가 여러 마리의 동물을 데리고 올 수 있습니다.
        보호자는 이름, 나이, 전화번호, 주소가 필요하고
        동물은 병명, 이름, 나이, 몸무게가 필요합니다.

    2. 개념 모델링
    보호자             동물
    -----------------------
    번호               번호
    -----------------------
    이름               이름
    나이               나이
    전화번호            병명
    주소               몸무게

    3. 논리 모델링
    보호자                동물
    ---------------------------
    번호PK               번호FK
    ---------------------------
    이름NN               이름NN
    나이NN               나이NN
    전화번호U, NN         병명NN
    주소NN               몸무게NN

    4. 물리 모델링
    tbl_owner
    -----------------------
    id: bigint primary key
    -----------------------
    name: varchar(255) not null,
    age: int not null,
    phone: varchar(255) unique not null,
    address: varchar(255)

    tbl_animals
    ------------------------
    id:FK
    name: varchar(255) not null,
    age: int not null,
    ill: varchar(255) not null
    weight: int not null

    5. 구현
*/
create table tbl_owner(
    id bigint primary key,
    name varchar(255) not null,
    age int not null,
    phone varchar(255) unique not null,
    address varchar(255) not null
);

create table tbl_animals(
    id bigint primary key,
    name varchar(255) default '사랑',
    age int default 0,
    ill varchar(255) not null,
    weight decimal(3, 2) default 0.0,
    owner_id bigint,
    constraint fk_animals_owner foreign key (owner_id)
                        references tbl_owner(id)
);

drop table tbl_owner, tbl_animals;

show tables;

/*
    1. 요구사항 분석
        안녕하세요 중고차 딜러입니다.
        이번에 자동차와 차주를 관리하고자 방문했습니다.
        자동차는 여러 명의 차주로 히스토리에 남아야 하고,
        차주는 여러대의 자동차를 소유할 수 있습니다.
        그래서 우리는 항상 등록증(Registration)을 작성합니다.
        자동차는 브랜드, 모델명, 가격, 출시날짜가 필요하고
        차주는 이름, 전화번호, 주소가 필요합니다.
    2. 개념 모델링
    자동차     등록증     차주
    --------------------------
    번호       번호      번호
    --------------------------
    브랜드               이름
    모델명               전화번호
    가격                 주소
    출시날짜

    3. 논리적 설계
    자동차     등록증              차주
    -------------------------------------
    번호PK     번호PK             번호PK
    -------------------------------------
    브랜드NN    자동차번호FK       이름NN
    모델명NN    차주번호FK         전화번호NN
    가격D=0                      주소NN
    출시날짜date

    4. 물리적 설계
    tbl_car
    -------------------------
    id: bigint primary key
    -------------------------
    car_brand: varchar(255) NN
    car_name: varchar(255) NN
    price: int default 0
    release_date: date

    tbl_owner
    -------------------------
    id: bigint primary key
    -------------------------


*/
create table tbl_car(
    id bigint primary key,
    car_brand varchar(255) not null,
    car_name varchar(255) not null,
    car_price int default 0,
    release_date date default (current_date)
);

create table tbl_owner(
    id bigint primary key,
    name varchar(255) not null,
    phone varchar(255) not null,
    address varchar(255) not null
);

create table tbl_registration(
    id bigint primary key,
    car_id bigint not null,
    owner_id bigint not null,
    constraint fk_registration_car foreign key (car_id)
                             references tbl_car(id),
    constraint fk_registration_owner foreign key (owner_id)
                             references tbl_owner(id)
);

drop table tbl_car, tbl_owner, tbl_registration;

show tables;
/*
    1. 요구사항
    커뮤니티 게시판을 만들고 싶어요.
    게시판에는 게시글 제목과 게시글 내용, 작성한 시간, 작성자가 있고,
    게시글에는 댓글이 있어서 댓글 내용들이 나와야 해요.
    작성자는 회원(TBL_USER)정보를 그대로 사용해요.
    댓글에도 작성자가 필요해요.

    게시판         작성자         댓글
    ---------------------------------
    번호           번호          번호
    ---------------------------------
    게시글 제목     아이디         작성자
    게시글 내용     비밀번호
    작성한 시간     이름
    작성자         주소
                  메일
                  생일
*/
create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_post(
    id bigint primary key,
    title varchar(255) not null,
    content varchar(255) not null,
    post_date datetime default current_timestamp,
    user_id bigint not null,
    constraint fk_post_user foreign key (user_id)
                     references tbl_user(id)
);



create table tbl_reple(
    id bigint primary key,
    post_id bigint not null,
    user_id bigint not null,
    constraint fk_reple_post foreign key (post_id)
                      references tbl_post(id),
    constraint fk_reple_user foreign key (user_id)
                      references tbl_user(id)
);

drop table tbl_reple, tbl_post, tbl_user;
/*
    요구사항

    마이페이지에서 회원 프로필을 구현하고 싶습니다.
    회원당 프로필을 여러 개 설정할 수 있고,
    대표 이미지로 선택된 프로필만 화면에 보여주고 싶습니다.

    회원      프로필     이미지
    --------------------------
    번호PK    번호PK    번호PK
    --------------------------
    아이디
    비밀번호
    이름
    주소
    이메일
    생일
*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

/*file_path: 파일의 경로
  bool타입은 문자열 varchar로 한다.*/
create table tbl_file(
    id bigint primary key,
    file_path varchar(255) default '/upload/',
    file_name varchar(255),
    is_main varchar(255) default 'ELSE',
    user_id bigint,
    constraint fk_profile_user foreign key (user_id)
                        references tbl_user(id)
);

/*
    요구사항

    학사 관리 시스템에 학생과 교수, 과목을 관리합니다.
    학생은 학번, 이름, 전공 학년이 필요하고
    교수는 교수 번호, 이름, 전공, 직위가 필요합니다.
    과목은 고유한 과목 번호와 과목명, 학점이 필요합니다.
    학생은 여러 과목을 수강할 수 있으며,
    교수는 여러 과목을 강의할 수 있습니다.
    학생이 수강한 과목은 성적(점수)이 모두 기록됩니다.

    학생    교수    과목
    --------------------
    학번pk  번호pk  과목번호pk
    ------------------------
    이름    이름    과목명
    전공    전공    학점
    학년    직위    학생번호FK
                   교수번호FK
*/
/*
auto_increment 숫자 자동증가
  */
create table tbl_student(
    id bigint auto_increment primary key,
    student_name varchar(255) not null,
    student_major varchar(255) not null,
    student_grade int default 1
);

create table tbl_professor(
    id bigint auto_increment primary key,
    professor_name varchar(255) not null,
    professor_major varchar(255) not null,
    position varchar(255) not null
);

create table tbl_major(
    id bigint auto_increment primary key,
    major_name varchar(255) unique not null,
    score int default 0
);
/*운영을 위한 테이블*/
/*학생수강*/
/*
처음에는 수강중이기 때문에 학점이 없으므로 grade는 null로 둔다.
 */

create table tbl_student_subject(
    id bigint auto_increment primary key,
    grade varchar(255),
    status varchar(255),
    student_id bigint not null,
    major_id bigint not null,
    professor_id bigint not null,
    constraint check_status check (status in('수강중', '수강완료')),
    constraint fk_student_subject_student foreign key (student_id)
                                references tbl_student(id),
    constraint fk_student_subject_professor foreign key (professor_id)
                                references tbl_professor(id),
    constraint fk_student_subject_major foreign key (major_id)
                                references tbl_major(id)
);

create table tbl_lecture(
    id bigint auto_increment primary key,
    professor_id bigint not null,
    major_id bigint not null,
    constraint fk_lecture_professor foreign key (professor_id)
                        references tbl_professor(id),
    constraint fk_lecture_major foreign key (major_id)
                        references tbl_major(id)
);


/*
    요구사항

    대카테고리, 소카테고리가 필요해요.
*/
/*
대카, 소카 이름지을때 뒤에 알파벳 붙여서 구분
*/
create table tbl_main_category(
    main_category_id bigint primary key,
    main_category_name varchar(255) not null
);

create table tbl_sub_category(
    sub_category_id bigint primary key,
    sub_category_name varchar(255) not null,
    main_category_id bigint not null,
    constraint fk_sub_category_main_category foreign key (main_category_id)
                               references tbl_main_category(main_category_id)
);
/*
    요구 사항

    회의실 예약 서비스를 제작하고 싶습니다.
    회원별로 등급이 존재하고 사무실마다 회의실이 여러 개 있습니다.
    회의실 이용 가능 시간은 파트 타임으로서 여러 시간대가 존재합니다.

    회원  사무실 회의실
    ----------------------------
    번호  번호  번호
    ------------------------------
    이름  회의실번호FK  시간
    나이
    등급
*/
/**/
create table tbl_member(
    member_id bigint primary key,
    member_name varchar(255) not null,
    member_age int default 0,
    member_grade varchar(255) default '기본',
    constraint check_member_grade check(member_grade in ('기본', '단골'))
);
/*사무실*/
create table tbl_office(
    office_id bigint primary key
);
/*회의실*/
create table tbl_conference_room(
    conference_room_id bigint primary key,
    office_id bigint not null,
    constraint kf_conference_room_office foreign key (office_id)
                                references tbl_office(office_id)
);
/*회의실 이용시간*/
create table available_time (
    time_id bigint primary key,
    start_time datetime default current_timestamp,
    end_time datetime default current_timestamp,
    conference_room_id bigint not null,
    constraint kf_available_time_conference_room foreign key (conference_room_id)
                            references tbl_conference_room(conference_room_id)
);
/*예약 테이블*/
create table tbl_reservation(
    id bigint auto_increment primary key,
    member_id bigint not null,
    conference_room_id bigint not null,
    time time not null,
    created_date datetime default (current_timestamp),
    constraint kf_reservation_member foreign key (member_id)
                            references tbl_member(member_id),
    constraint kf_reservation_conference_room foreign key (conference_room_id)
                            references tbl_conference_room(conference_room_id)
);

/*
    요구사항

    유치원을 하려고 하는데, 아이들이 체험학습 프로그램을 신청해야 합니다.
    아이들 정보는 이름, 나이, 성별이 필요하고 학부모는 이름, 나이, 주소, 전화번호, 성별이 필요해요
    체험학습은 체험학습 제목, 체험학습 내용, 이벤트 이미지 여러 장이 필요합니다.
    아이들은 여러 번 체험학습에 등록할 수 있어요.
*/
create table tbl_parents(
    parents_id bigint primary key,
    parents_name varchar(255) not null,
    parents_age int default 0,
    address varchar(255) not null,
    phone varchar(255) unique not null,
    parents_gender varchar(255) not null
);

create table tbl_children(
    children_id bigint primary key,
    children_name varchar(255) not null,
    children_age int default 0,
    children_gender varchar(255) not null
);



create table field_trip(
    field_trip_id bigint primary key,
    field_trip_title varchar(255) not null,
    field_trip_content varchar(255) not null
);

/*체험학습 신청 테이블*/
create table tbl_file(
    /*super key*/
    id bigint auto_increment primary key,
    file_path varchar(255) not null,
    file_name varchar(255) not null
);

create table tbl_field_trip_file(
    /*sub key*/
    id bigint primary key,
    field_trip_id bigint not null,
    constraint fk_field_trip_file_file foreign key (id)
                                references tbl_file(id),
    constraint fk_field_trip_file_field_trip foreign key (id)
                                references tbl_field_trip(id)
);

/*체험학습 지원*/
create table tbl_apply(
    id bigint auto_increment primary key,
    child_id bigint not null,
    field_trip_id bigint not null,
    constraint fk_apply_child foreign key (child_id)
                      references tbl_children(children_id),

)
/*
    요구사항

    안녕하세요, 광고 회사를 운영하려고 준비중인 사업가입니다.
    광고주는 기업이고 기업 정보는 이름, 주소, 대표번호, 기업종류(스타트업, 중소기업, 중견기업, 대기업)입니다.
    광고는 제목, 내용이 있고 기업은 여러 광고를 신청할 수 있습니다.
    기업이 광고를 선택할 때에는 카테고리로 선택하며, 대카테고리, 중카테고리, 소카테고리가 있습니다.
*/

create table tbl_company(
    company_id bigint primary key,
    company_name varchar(255) not null,
    company_address varchar(255) not null,
    company_phone varchar(255) unique not null,
    company_type enum('스타트업', '중소기업', '중견기업', '대기업') not null
);

create table tbl_ad
(
    ad_id           bigint primary key,
    ad_title        varchar(255) not null,
    ad_content      varchar(255) not null,
    company_id      bigint       not null,
    company_type_id bigint       not null,
    constraint kf_ad_company foreign key (company_id)
        references tbl_company (company_id)
);

create table tbl_ad_category(
    category_id bigint primary key,
    category_huge varchar(255) not null,
    category_middle varchar(255) not null,
    category_small varchar(255) not null,
    ad_id bigint not null,
    constraint kf_ad_category_ad foreign key (ad_id)
                            references tbl_ad(ad_id)
);

/*
    요구사항

    음료수 판매 업체입니다. 음료수마다 당첨번호가 있습니다.
    음료수의 당첨번호는 1개이고 당첨자의 정보를 알아야 상품을 배송할 수 있습니다.
    당첨 번호마다 당첨 상품이 있고, 당첨 상품이 배송 중인지 배송 완료인지 구분해야 합니다.
*/
/*꽝이 있으므로 not null해제*/
create table tbl_beverage(
    beverage_id bigint primary key,
    baverage_name varchar(255) not null
);

create table tbl_prize(
    prize_id bigint primary key,
    prize_name varchar(255) not null,
    prize_delivery enum('배송 중', '배송 완료') not null
);

create table tbl_winner(
    winner_id bigint primary key,
    winner_name varchar(255) not null,
    winner_email varchar(255) unique not null,
    winner_address varchar(255) not null,
    beverage_id bigint not null,
    prize_id bigint not null,
    constraint kf_winner_beverage foreign key (beverage_id)
                       references tbl_beverage(beverage_id),
    constraint kf_winner_prize foreign key (prize_id)
                       references tbl_prize(prize_id)
);

/*당첨 후 배송 테이블*/


/*
    요구사항

    이커머스 창업 준비중입니다. 기업과 사용자 간 거래를 위해 기업의 정보와 사용자 정보가 필요합니다.
    기업의 정보는 기업 이름, 주소, 대표번호가 있고
    사용자 정보는 이름, 주소, 전화번호가 있습니다. 결제 시 사용자 정보와 기업의 정보, 결제한 카드의 정보 모두 필요하며,
    상품의 정보도 필요합니다. 상품의 정보는 이름, 가격, 재고입니다.
    사용자는 등록한 카드의 정보를 저장할 수 있으며, 카드의 정보는 카드번호, 카드사, 회원 정보가 필요합니다.
*/
create table tbl_company_info (
    company_info_id bigint auto_increment primary key,
    company_info_name varchar(255) not null,
    company_info_address varchar(255) not null,
    company_info_phone varchar(255) unique not null
);

create table tbl_user_info(
    user_info_id bigint primary key,
    user_info_name varchar(255) not null,
    user_info_address varchar(255) not null,
    user_info_phone varchar(255) unique not null
);

create table tbl_product_info(
    product_info_id bigint primary key,
    product_info_name varchar(255) not null,
    product_info_price int default 0,
    product_info_stock int default 0,
    company_info_id bigint not null,
    constraint fk_product_info_company_info foreign key (company_info_id)
                             references tbl_company_info(company_info_id)
);

create table tbl_card(
    card_id bigint primary key,
    card_number varchar(255) unique not null,
    card_company varchar(255) not null,
    user_info_id bigint not null,
    constraint kf_card_user_info foreign key (user_info_id)
                     references tbl_user_info(user_info_id)
);
/*조합키로 쓰기*/
#12시가 됐을때 1부터 다시 카운트 시작
create table tbl_sequence(
    id bigint auto_increment primary key,
    sequence bigint default 0
);

create table tbl_payment(
    payment_id bigint,
    created_date date default (current_date),
    primary key (payment_id, created_date),
    company_info_id bigint not null,
    user_info_id bigint not null,
    product_info_id bigint not null,
    card_id bigint not null,
    constraint kf_payment_company_info foreign key (company_info_id)
                        references tbl_company_info(company_info_id),
    constraint kf_payment_user_info foreign key (user_info_id)
                        references tbl_user_info(user_info_id),
    constraint kf_payment_product_info foreign key (product_info_id)
                        references tbl_product_info(product_info_id),
    constraint kf_payment_card foreign key (card_id)
                        references tbl_card(card_id)
);