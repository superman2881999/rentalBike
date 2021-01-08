import 'package:flutter/material.dart';

import '../../authentication/authentication.dart';
import 'slider_page.dart';


///Lớp này để giới thiệu về tiêu chí app của chúng tôi
/// @return: Trả về instance của class _LandingState extend từ State<>
class Landing extends StatefulWidget {
  //Trả về instance của class _LandingState extend từ State<>
  @override
  _LandingState createState() => _LandingState();
}
///Hiển thị các màn hình dạng slide
class _LandingState extends State<Landing> {
  int _currentPage = 0;
  final PageController _controller = PageController();
  // List chứa slide
  final List<Widget> _pages = [
    const SliderPage(
        description: "Chào mừng bạn đến với thế giới xe của chúng tôi",
        image: "images/xedapdiendo.jpg"),
    const SliderPage(
        description:
            "Đặt nhu cầu của người dùng lên hàng đầu với giá cả hợp lý",
        image: "images/xedapdienden.jpg"),
    const SliderPage(
        description: "Cùng khám phá dịch vụ thuê xe của chúng tôi nhé !!!",
        image: "images/xedapdienxanh.jpg"),
  ];
  // hàm cập nhật slide hiện tại đang dừng
  void _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
  //trả về giao diện slide page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onchanged,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_pages.length, (index) {
                    return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.red
                                : Colors.redAccent.withOpacity(0.5)));
                  })),
              InkWell(
                onTap: () {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint);
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 300),
                  height: 70,
                  width: (_currentPage == (_pages.length - 1)) ? 200 : 75,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(35)),
                  child: (_currentPage == (_pages.length - 1))
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Authentication()));
                          },
                          child: const Text(
                            "Let's Go",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.navigate_next,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
