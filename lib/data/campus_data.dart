import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';

class CampusData {
  // Campus center coordinates for Govt. Islamia Graduate College (W), Cooper Road, Lahore
  static const LatLng campusCenter = LatLng(31.5641, 74.3309);
  static const String campusName =
      "Govt. Islamia Graduate College(w) Cooper Road, Lahore";

  // Static list of all campus locations
  static final List<CampusLocation> locations = [
    // ====== ADMIN BLOCK ======
    // Ground Floor
    CampusLocation(
      id: 'admin_clerk_office',
      name: 'Clerk Office',
      description: 'Administrative clerk office for general student services.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Document Processing', 'Student Services'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-GF',
      floor: 0,
      imageUrl: 'https://i.imgur.com/czSmX8Z.jpeg',
    ),
    CampusLocation(
      id: 'admin_principal_office',
      name: 'Principal Office',
      description: 'Office of the College Principal.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Administration', 'Meeting Room'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-GF',
      floor: 0,
      imageUrl: 'https://i.ibb.co/nNYh5RYT/Admin-block-GF-principal-office.jpg',
    ),
    CampusLocation(
      id: 'admin_computer_office',
      name: 'Computer Office',
      description: 'IT and computer services office.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['IT Support', 'Computer Services'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-GF',
      floor: 0,
      imageUrl: 'https://i.ibb.co/4gn7Bvk2/GF-Computer-office.jpg',
    ),
    CampusLocation(
      id: 'admin_student_dealing',
      name: 'Student Dealing Office',
      description: 'Office for student affairs and dealing.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Student Services', 'Counseling'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-GF',
      floor: 0,
      imageUrl: 'https://i.ibb.co/K8kLn4J/GF-stu-dealing-office.jpg',
    ),
    CampusLocation(
      id: 'admin_vice_principal',
      name: 'Vice Principal Office',
      description: 'Office of the Vice Principal.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Administration', 'Academic Affairs'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-GF',
      floor: 0,
      imageUrl:
          'https://i.ibb.co/ymhJmqvk/Admin-block-GF-vice-principal-office.jpg',
    ),

    // First Floor
    CampusLocation(
      id: 'admin_conference',
      name: 'Conference Office',
      description: 'Conference and meeting room.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Meeting Room', 'Audio-Visual'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-FF',
      floor: 1,
      imageUrl: 'https://i.ibb.co/V0Dm0Wkk/f1-conference-room.jpg',
    ),
    CampusLocation(
      id: 'admin_exam_record',
      name: 'Examination Record Room',
      description: 'Examination records and documentation office.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.administrative,
      facilities: ['Records', 'Archives'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'ADMIN-FF',
      floor: 1,
      imageUrl: 'https://i.ibb.co/qLGYMKd3/f1-examination-record-room.jpg',
    ),
    CampusLocation(
      id: 'admin_persian',
      name: 'Persian Room',
      description: 'BS-TSOL Senior Semesters classroom for Persian studies.',
      coordinates: const LatLng(31.563799025115983, 74.3254454596577),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Language Lab'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'ADMIN-FF',
      floor: 1,
      imageUrl: 'https://i.imgur.com/TwnVjq2.jpeg',
    ),

    // Admin Block Part
    CampusLocation(
      id: 'admin_main_staff',
      name: 'Main Staff Room',
      description: 'Primary staff room for faculty members.',
      coordinates: const LatLng(31.56387215779624, 74.32542400198638),
      category: LocationCategory.administrative,
      facilities: ['Faculty Lounge', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'ADMIN',
      imageUrl: 'https://i.ibb.co/mVqWHQxn/GF-main-staffroom.jpg',
    ),
    CampusLocation(
      id: 'admin_namaz_room',
      name: 'Namaz Room',
      description: 'Prayer room (Backside of Admin Block).',
      coordinates: const LatLng(31.56387215779624, 74.32542400198638),
      category: LocationCategory.other,
      facilities: ['Prayer Space', 'Wudu Area'],
      openingHours: 'All Day',
      buildingCode: 'ADMIN',
      imageUrl: 'https://i.ibb.co/d4CKWRmn/GF-namaz-room.jpg',
    ),
    CampusLocation(
      id: 'admin_math_staff',
      name: 'Mathematics Staff Room',
      description: 'Staff room for Mathematics department faculty.',
      coordinates: const LatLng(31.56387215779624, 74.32542400198638),
      category: LocationCategory.administrative,
      facilities: ['Faculty Offices', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'ADMIN',
      imageUrl: 'https://i.ibb.co/fGT2vhYg/GF-maths-staffroom.jpg',
    ),

    // ====== URDU BLOCK ======
    // Ground Floor
    CampusLocation(
      id: 'urdu_staff_room_23',
      name: 'Staff Room - Room 23',
      description: 'Faculty staff room in Urdu Block.',
      coordinates: const LatLng(31.564275234438234, 74.3249350585021),
      category: LocationCategory.administrative,
      facilities: ['Faculty Lounge', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'URDU-23',
      floor: 0,
      imageUrl: 'https://i.ibb.co/jkWgp28d/GF-r23.jpg',
    ),
    CampusLocation(
      id: 'urdu_computer_lab_26',
      name: 'Computer Lab - Room 26',
      description: 'Computer laboratory in Urdu Block.',
      coordinates: const LatLng(31.564275234438234, 74.3249350585021),
      category: LocationCategory.lab,
      facilities: ['Computers', 'Printers', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'URDU-26',
      floor: 0,
      imageUrl: 'https://i.ibb.co/FqsQ842T/GF-IT-lab.jpg',
    ),
    CampusLocation(
      id: 'urdu_ma_2nd_year_24',
      name: '2nd Year M.A Urdu - Room 24',
      description: 'Classroom for M.A Urdu 2nd year students.',
      coordinates: const LatLng(31.564275234438234, 74.3249350585021),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'URDU-24',
      floor: 0,
      imageUrl: 'https://i.ibb.co/TMLHPZrx/GF-r24.jpg',
    ),
    CampusLocation(
      id: 'urdu_book_shop',
      name: 'Book Shop',
      description: 'Campus bookstore for textbooks and supplies.',
      coordinates: const LatLng(31.56400013984872, 74.32548837500035),
      category: LocationCategory.other,
      facilities: ['Textbooks', 'Stationery', 'Reference Books'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'URDU-GF',
      floor: 0,
      imageUrl: 'https://i.ibb.co/RpbZBNgj/GF-printshop.jpg',
    ),

    // First Floor - Intermediate Rooms
    ...List.generate(5, (index) {
      final roomNumber = 30 + index;
      return CampusLocation(
        id: 'urdu_inter_room_$roomNumber',
        name: 'Intermediate Room $roomNumber',
        description: 'Classroom for intermediate students.',
        coordinates: const LatLng(31.564275234438234, 74.3249350585021),
        category: LocationCategory.academic,
        facilities: ['Classroom', 'Blackboard'],
        openingHours: '8:00 AM - 6:00 PM',
        buildingCode: 'URDU-$roomNumber',
        floor: 1,
        imageUrl: 'https://i.imgur.com/AbfUpc8.jpeg',
      );
    }),

    // Second Floor - Intermediate Rooms
    ...List.generate(5, (index) {
      final roomNumber = 37 + index;
      return CampusLocation(
        id: 'urdu_inter_room_$roomNumber',
        name: 'Intermediate Room $roomNumber',
        description: 'Classroom for intermediate students.',
        coordinates: const LatLng(31.564275234438234, 74.3249350585021),
        category: LocationCategory.academic,
        facilities: ['Classroom', 'Blackboard'],
        openingHours: '8:00 AM - 6:00 PM',
        buildingCode: 'URDU-$roomNumber',
        floor: 2,
        imageUrl: 'https://i.imgur.com/AbfUpc8.jpeg',
      );
    }),

    // ====== BS-4YD BLOCK ======
    // Ground Floor
    CampusLocation(
      id: 'bs_tsol_n1',
      name: 'BS-TSOL Room N-1',
      description: 'BS Teaching of Spoken Languages classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Language Lab'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-N1',
      floor: 0,
      imageUrl: 'https://i.ibb.co/9kZmDzhp/GF-r-N1.jpg',
    ),
    CampusLocation(
      id: 'bs_tsol_n2',
      name: 'BS-TSOL Room N-2',
      description: 'BS Teaching of Spoken Languages classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Language Lab'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-N2',
      floor: 0,
      imageUrl: 'https://i.ibb.co/dswMqgFR/GF-r-N2.jpg',
    ),
    CampusLocation(
      id: 'bs_english_dept_92',
      name: 'English Department - Room 92',
      description: 'English Department office and faculty room.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.administrative,
      facilities: ['Faculty Offices', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-92',
      floor: 0,
      imageUrl: 'https://i.ibb.co/HD9qw4kY/GF-eng-dep-r92.jpg',
    ),
    CampusLocation(
      id: 'bs_poli_sci_sem1_91',
      name: 'BS Political Science (Sem 1) - Room 91',
      description: 'BS Political Science Semester 1 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-91',
      floor: 0,
      imageUrl: 'https://i.ibb.co/XZnNR103/GF-r91.jpg',
    ),
    CampusLocation(
      id: 'bs_poli_sci_sem3_91a',
      name: 'BS Political Science (Sem 3) - Room 91A',
      description: 'BS Political Science Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-91A',
      floor: 0,
      imageUrl: 'https://i.imgur.com/xReVhgt.jpeg',
    ),
    CampusLocation(
      id: 'bs_poli_sci_sem5_90a',
      name: 'BS Political Science (Sem 5) - Room 90A',
      description: 'BS Political Science Semester 5 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-90A',
      floor: 0,
      imageUrl: 'https://i.ibb.co/XZnNR103/GF-r91.jpg',
    ),
    CampusLocation(
      id: 'bs_poli_sci_sem7_90',
      name: 'BS Political Science (Sem 7) - Room 90',
      description: 'BS Political Science Semester 7 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-90',
      floor: 0,
      imageUrl: 'https://i.ibb.co/6ct6QBtZ/GF-r90.jpg',
    ),
    CampusLocation(
      id: 'bs_english_89',
      name: 'BS English - Room 89',
      description: 'BS English program classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-89',
      floor: 0,
      imageUrl: 'https://i.ibb.co/spN6GvSd/GF-r89.jpg',
    ),
    CampusLocation(
      id: 'bs_english_sem3_88',
      name: 'BS English (Sem 3) - Room 88',
      description: 'BS English Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-88',
      floor: 0,
      imageUrl: 'https://i.imgur.com/xReVhgt.jpeg',
    ),
    CampusLocation(
      id: 'bs_cs_sem3_87',
      name: 'BS Computer Science (Sem 3) - Room 87',
      description: 'BS Computer Science Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector', 'Computers'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-87',
      floor: 0,
      imageUrl: 'https://i.imgur.com/xReVhgt.jpeg',
    ),

    // First Floor
    CampusLocation(
      id: 'bs_edu_staff_96',
      name: 'Educational Department Staff Room - Room 96',
      description: 'Education department faculty office.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.administrative,
      facilities: ['Faculty Offices', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-96',
      floor: 1,
      imageUrl: 'https://i.ibb.co/WWcySHxp/f1r96-edu-dep.jpg',
    ),
    CampusLocation(
      id: 'bs_edu_sem7_95',
      name: 'BS Education (Sem 7) - Room 95',
      description: 'BS Education Semester 7 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-95',
      floor: 1,
      imageUrl: 'https://i.ibb.co/F4rJZdRN/f1r95.jpg',
    ),
    CampusLocation(
      id: 'bs_edu_sem5_94',
      name: 'BS Education (Sem 5) - Room 94',
      description: 'BS Education Semester 5 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-94',
      floor: 1,
      imageUrl: 'https://i.ibb.co/C5yqtqxS/f1r94.jpg',
    ),
    CampusLocation(
      id: 'bs_edu_sem3_93',
      name: 'BS Education (Sem 3) - Room 93',
      description: 'BS Education Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-93',
      floor: 1,
      imageUrl: 'https://i.ibb.co/C5nt8n38/f1-r93.jpg',
    ),
    CampusLocation(
      id: 'bs_edu_sem1_97',
      name: 'BS Education (Sem 1) - Room 97',
      description: 'BS Education Semester 1 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-97',
      floor: 1,
      imageUrl: 'https://i.ibb.co/TMc93nYd/f1r97-eco-dep.jpg',
    ),
    CampusLocation(
      id: 'bs_econ_sem7_98',
      name: 'BS Economics (Sem 7) - Room 98',
      description: 'BS Economics Semester 7 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-98',
      floor: 1,
      imageUrl: 'https://i.ibb.co/Zs0TfLT/f1r98.jpg',
    ),
    CampusLocation(
      id: 'bs_econ_sem5_99',
      name: 'BS Economics (Sem 5) - Room 99',
      description: 'BS Economics Semester 5 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-99',
      floor: 1,
      imageUrl: 'https://i.ibb.co/nNwKGFsZ/f1r99.jpg',
    ),
    CampusLocation(
      id: 'bs_econ_sem3_n3',
      name: 'BS Economics (Sem 3) - Room N-3',
      description: 'BS Economics Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-N3',
      floor: 1,
      imageUrl: 'https://i.ibb.co/PzC9RkYc/f1-r-N3.jpg',
    ),
    CampusLocation(
      id: 'bs_econ_sem1_n4',
      name: 'BS Economics (Sem 1) - Room N-4',
      description: 'BS Economics Semester 1 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-N4',
      floor: 1,
      imageUrl: 'https://i.ibb.co/NwTnfBf/f1r-N4.jpg',
    ),

    // Second Floor
    CampusLocation(
      id: 'bs_room_103',
      name: 'Room 103',
      description: 'General classroom in BS Block.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-103',
      floor: 2,
      imageUrl: 'https://i.ibb.co/W4gSMh5h/f2-r103.jpg',
    ),
    CampusLocation(
      id: 'bs_cs_lab_102',
      name: 'Computer Lab (Section B Sem 1) - Room 102',
      description:
          'Computer laboratory inaugurated by Syed Zaeem Hussain Qadri.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.lab,
      facilities: ['Computers', 'Projector', 'WiFi', 'AC'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-102',
      floor: 2,
      imageUrl: 'https://i.ibb.co/0zXfThy/f2-r102.jpg',
    ),
    CampusLocation(
      id: 'bs_room_101',
      name: 'Room 101',
      description: 'General classroom in BS Block.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-101',
      floor: 2,
      imageUrl: 'https://i.ibb.co/pB2r4L4F/f2-r101.jpg',
    ),
    CampusLocation(
      id: 'bs_cs_sem3_100',
      name: 'BS Computer Science (Sem 3) - Room 100',
      description: 'BS Computer Science Semester 3 classroom.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Computers'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-100',
      floor: 2,
      imageUrl: 'https://i.ibb.co/JWpjKSkq/f2-r100.jpg',
    ),
    CampusLocation(
      id: 'bs_cs_lab_104',
      name: 'Lab for M.As / BS Computer Science Section A (Sem 1) - Room 104',
      description:
          'Advanced computer laboratory for postgraduate and BS students.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.lab,
      facilities: ['Computers', 'Projector', 'WiFi', 'Software Tools'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-104',
      floor: 2,
      imageUrl: 'https://i.ibb.co/LDrGy4gv/f2-r104.jpg',
    ),
    CampusLocation(
      id: 'bs_room_105',
      name: 'Room 105',
      description: 'General classroom in BS Block.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Classroom'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-105',
      floor: 2,
      imageUrl: 'https://i.ibb.co/LzKKmyC0/f2-r105.jpg',
    ),
    CampusLocation(
      id: 'bs_fine_arts_106',
      name: 'Fine Arts - Room 106',
      description: 'Fine Arts department classroom and studio.',
      coordinates: const LatLng(31.5639, 74.3312),
      category: LocationCategory.academic,
      facilities: ['Art Studio', 'Art Supplies', 'Exhibition Space'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'BS-106',
      floor: 2,
      imageUrl: 'https://i.ibb.co/BVwHLRT9/f2-106.jpg',
    ),

    // ====== OTHER FACILITIES ======
    CampusLocation(
      id: 'cafeteria',
      name: 'Cafeteria',
      description: 'Campus dining facility serving meals and snacks.',
      coordinates: const LatLng(31.564460990688076, 74.32630162698605),
      category: LocationCategory.cafeteria,
      facilities: ['Dining Area', 'Food Court', 'Snacks', 'Beverages'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'CAF',
      imageUrl: 'https://i.imgur.com/m5NQRLw.jpeg',
    ),
    CampusLocation(
      id: 'library',
      name: 'Library',
      description:
          'College library with extensive collection of books and digital resources.',
      coordinates: const LatLng(31.56388398322253, 74.32530112487576),
      category: LocationCategory.library,
      facilities: [
        'Reading Rooms',
        'Digital Library',
        'Reference Books',
        'WiFi',
        'Study Areas',
      ],
      openingHours: '8:00 AM - 1:00 PM',
      buildingCode: 'LIB',
      imageUrl: 'https://i.ibb.co/NdJbL59m/GF-Library.jpg',
    ),
    CampusLocation(
      id: 'hostel',
      name: 'Hostel',
      description: 'Student residential facility.',
      coordinates: const LatLng(31.563938832688116, 74.32517237884791),
      category: LocationCategory.hostel,
      facilities: ['Rooms', 'Mess', 'Common Room', 'WiFi', 'Security'],
      openingHours: '24/7',
      buildingCode: 'HST',
      imageUrl: 'https://i.imgur.com/jM56bLZ.jpeg',
    ),
    CampusLocation(
      id: 'auditorium',
      name: 'Auditorium / Shajauddin Hall',
      description:
          'Main auditorium for events, seminars, and cultural programs.',
      coordinates: const LatLng(31.56444270763882, 74.32645183068523),
      category: LocationCategory.auditorium,
      facilities: ['Stage', 'Seating', 'Audio-Visual', 'AC'],
      openingHours: 'Event Based',
      buildingCode: 'AUD',
      imageUrl: 'https://i.imgur.com/aY2S2Ne.jpeg',
    ),
    CampusLocation(
      id: 'chem_staff_room',
      name: 'Chemistry Staff Room',
      description:
          'Faculty office for Chemistry department (Ground Floor, Auditorium Building).',
      coordinates: const LatLng(31.56442442458599, 74.32628016931474),
      category: LocationCategory.administrative,
      facilities: ['Faculty Offices', 'WiFi'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'AUD-CHEM',
      floor: 0,
      imageUrl: 'https://i.imgur.com/m1VGpXf.jpeg',
    ),
    CampusLocation(
      id: 'chem_lab',
      name: 'Chemistry Lab',
      description:
          'Chemistry laboratory for practical experiments (Ground Floor, Auditorium Building).',
      coordinates: const LatLng(31.56442442458599, 74.32628016931474),
      category: LocationCategory.lab,
      facilities: ['Lab Equipment', 'Chemicals', 'Safety Gear', 'Fume Hoods'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'AUD-LAB',
      floor: 0,
      imageUrl: 'https://i.imgur.com/XI2dOst.jpeg',
    ),
    CampusLocation(
      id: 'chem_class',
      name: 'Chemistry Class',
      description:
          'Chemistry classroom for lectures (Ground Floor, Auditorium Building).',
      coordinates: const LatLng(31.56442442458599, 74.32628016931474),
      category: LocationCategory.academic,
      facilities: ['Classroom', 'Projector', 'Blackboard'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'AUD-CLASS',
      floor: 0,
      imageUrl: 'https://i.imgur.com/XI2dOst.jpeg',
    ),
    CampusLocation(
      id: 'physics_lab_room1',
      name: 'Physics Lab Room 1',
      description: 'Physics laboratory for experiments and practical work.',
      coordinates: const LatLng(31.564333009268015, 74.32634454232867),
      category: LocationCategory.lab,
      facilities: ['Lab Equipment', 'Apparatus', 'Workbenches'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'PHY-1',
      imageUrl: 'https://i.ibb.co/4RLmVwTY/Phy-lab-r77.jpg',
    ),
    CampusLocation(
      id: 'physics_lab_room2',
      name: 'Physics Lab Room 2',
      description: 'Physics laboratory for experiments and practical work.',
      coordinates: const LatLng(31.564333009268015, 74.32634454232867),
      category: LocationCategory.lab,
      facilities: ['Lab Equipment', 'Apparatus', 'Workbenches'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'PHY-2',
      imageUrl: 'https://i.ibb.co/S4nQ5WVn/Phy-lab-r78.jpg',
    ),
    CampusLocation(
      id: 'dean_office',
      name: 'Dean Office Block',
      description: 'Office of the Dean of College.',
      coordinates: const LatLng(31.564283530276516, 74.32488747270142),
      category: LocationCategory.administrative,
      facilities: ['Administration', 'Meeting Room'],
      openingHours: '9:00 AM - 5:00 PM',
      buildingCode: 'DEAN',
      imageUrl: 'https://i.imgur.com/iUBVIyZ.jpeg',
    ),
    CampusLocation(
      id: 'islamiyat_basement',
      name: 'Islamiyat Basement Block',
      description: 'Islamiyat department classrooms and offices.',
      coordinates: const LatLng(31.5639, 74.3310),
      category: LocationCategory.academic,
      facilities: ['Classrooms', 'Faculty Offices'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'ISL',
      imageUrl: 'https://i.ibb.co/d4PSN2jC/basement-building.jpg',
    ),
    CampusLocation(
      id: 'zoology_block',
      name: 'Zoology Block',
      description: 'Zoology department with labs and classrooms.',
      coordinates: const LatLng(331.56456611815174, 74.32633381349302),
      category: LocationCategory.academic,
      facilities: ['Classrooms', 'Zoology Lab', 'Specimens', 'Microscopes'],
      openingHours: '8:00 AM - 6:00 PM',
      buildingCode: 'ZOO',
      imageUrl: 'https://i.imgur.com/TPZMDfg.jpeg',
    ),
  ];

  // Get locations by category
  static List<CampusLocation> getLocationsByCategory(
    LocationCategory category,
  ) {
    return locations.where((loc) => loc.category == category).toList();
  }

  // Search locations
  static List<CampusLocation> searchLocations(String query) {
    if (query.isEmpty) return locations;

    final lowerQuery = query.toLowerCase();
    return locations.where((loc) {
      return loc.name.toLowerCase().contains(lowerQuery) ||
          loc.description.toLowerCase().contains(lowerQuery) ||
          loc.buildingCode?.toLowerCase().contains(lowerQuery) == true ||
          loc.facilities.any((f) => f.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get location by ID
  static CampusLocation? getLocationById(String id) {
    try {
      return locations.firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get all categories with location count
  static Map<LocationCategory, int> getCategoryCounts() {
    final Map<LocationCategory, int> counts = {};
    for (var category in LocationCategory.values) {
      counts[category] =
          locations.where((loc) => loc.category == category).length;
    }
    return counts;
  }

  // Get locations by floor
  static List<CampusLocation> getLocationsByFloor(int floor) {
    return locations.where((loc) => loc.floor == floor).toList();
  }

  // Get locations by building code
  static List<CampusLocation> getLocationsByBuildingCode(String buildingCode) {
    return locations
        .where(
          (loc) =>
              loc.buildingCode?.toLowerCase().contains(
                    buildingCode.toLowerCase(),
                  ) ==
              true,
        )
        .toList();
  }
}
