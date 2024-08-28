import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Industrial_page.dart';
import 'package:myapp/ame_page.dart';
import 'package:myapp/computer_page.dart';
import 'package:myapp/die_page.dart';
import 'package:myapp/le_page.dart';
import 'package:myapp/me_page.dart';

class DetailPage extends StatelessWidget {
  final String name; // รับชื่อใน constructor

  DetailPage({required this.name});

  @override
  Widget build(BuildContext context) {
    final filteredName =
        name.replaceAll(RegExp(r'\d'), ''); // กรองตัวเลขออกจากชื่อ

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Row(
            children: [
              Icon(Icons.person_4,
                  color: const Color.fromARGB(255, 67, 147, 232)),
              SizedBox(width: 8),
              Text(
                'HELLO! $filteredName',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.network(
              'https://scontent.fkkc4-1.fna.fbcdn.net/v/t39.30808-6/307288313_462240969275846_3197098443053206729_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=86c6b0&_nc_ohc=m9IWhS_4hJ4Q7kNvgFWnHU-&_nc_ht=scontent.fkkc4-1.fna&oh=00_AYCCsx0Sso2msRPUwjxEB1AI4CqPdnkk5-FU6RG-lI1FCQ&oe=66D3C8D4',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
          ),
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        'คณะวิศวกรรมศาสตร์และเทคโนโลยีอุตสาหกรรม มหาวิทยาลัยกาฬสินธุ์',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 66, 61, 61),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'กรุณาเลือกสาขา เพื่อระบุข้อมูลของคุณ',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 207, 69, 69),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Computer Engineering',
                        'https://scontent.fkkc4-1.fna.fbcdn.net/v/t1.6435-9/106039448_287285975984784_1307827805049552368_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=2285d6&_nc_ohc=Axc9g4BNcXUQ7kNvgFMDCb_&_nc_ht=scontent.fkkc4-1.fna&oh=00_AYCqB1buo1YjvozF2-OhJ1mLjQZXh7G8RtQPlucZNDc0Pg&oe=66F56800',
                        'สาขาวิศวกรรมคอมพิวเตอร์และระบบอัตโนมัติ',
                        ComputerPage(),
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Industrial Engineering',
                        'https://scontent.fkkc4-2.fna.fbcdn.net/v/t39.30808-6/324940555_702190458096173_274140104695249443_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=4uiId6nbw54Q7kNvgFln7PK&_nc_ht=scontent.fkkc4-2.fna&oh=00_AYBZK0mYhGKGH97a89tXMfLJHHbW-AA2tWqdD6fcwSrFTA&oe=66D3D9EA',
                        'สาขาวิศวกรรมอุตสาหการ',
                        IndustrialPage(),
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Mechanical and Mechatronics Engineering',
                        'https://scontent.fkkc4-2.fna.fbcdn.net/v/t1.6435-9/116837185_131143675336057_4109339843323996231_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=a5f93a&_nc_ohc=8qyYj2n9kEAQ7kNvgG1Memw&_nc_ht=scontent.fkkc4-2.fna&oh=00_AYBAm-985mXB8tyVnjl2HFAT8f7BJKRMcSmKrvZXY7Nufw&oe=66F57114',
                        'สาขาวิชาวิศวกรรมเครื่องกลและเมคคาทรอนิกส์',
                        MechanicalPage(),
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Logistics Engineering',
                        'https://scontent.fkkc4-2.fna.fbcdn.net/v/t39.30808-6/380489193_793346312587867_3579191899915274905_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=GN-jkx2bkcoQ7kNvgHhhUeu&_nc_ht=scontent.fkkc4-2.fna&_nc_gid=AUw7f6veFdHdhQy53M2Ss6Y&oh=00_AYB0pPJhoMhrXhOIsLBqu-CWkuTH3gKgs3pCwjBnzMzaHg&oe=66D3E5EC',
                        'สาขาวิชาวิศวกรรมโลจิสติกส์',
                        LogisticsPage(),
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Innovative design and architecture',
                        'https://scontent.fkkc4-2.fna.fbcdn.net/v/t39.30808-6/366681280_778601370935949_2002793168511170915_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=GbdsfXeFW30Q7kNvgGc_Y-d&_nc_ht=scontent.fkkc4-2.fna&oh=00_AYDsDGXR7VzaClktB42hKlCs43_zaXJGmxJvTiQF6IoStw&oe=66D3F026',
                        'สาขาวิชานวัตกรรมการออกแบบและสถาปัตยกรรม',
                        DiePage(),
                      ),
                      SizedBox(height: 15),
                      _buildCourseButton(
                        context,
                        'Agricultural Machinery Engineering',
                        'https://scontent.fkkc4-2.fna.fbcdn.net/v/t39.30808-6/409730722_122116358564118458_3342895415048958687_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=tPuVi2zbqfMQ7kNvgEvKjVA&_nc_ht=scontent.fkkc4-2.fna&oh=00_AYCjIhVMD1uzmbnepvnxYZXaI6GaX0JEPd0H0vYwmBcPrw&oe=66D3F3C9',
                        'สาขาวิศวกรรมเครื่องจักรกลการเกษตร',
                        AmePage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseButton(BuildContext context, String title, String imageUrl,
      String description, Widget page) {
    return SizedBox(
      width: 280,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: Colors.blueAccent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
