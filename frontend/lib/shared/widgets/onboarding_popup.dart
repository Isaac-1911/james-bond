import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OnboardingPopup extends StatefulWidget {
  final List<String> images;
  final VoidCallback onClose;

  const OnboardingPopup({
    super.key,
    required this.images,
    required this.onClose,
  });

  @override
  State<OnboardingPopup> createState() => _OnboardingPopupState();
}

class _OnboardingPopupState extends State<OnboardingPopup> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 40,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 240,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      autoPlay: widget.images.length > 1,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Color(0xFF6E6E73),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.images.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF007AFF)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: _currentPage == index
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF007AFF,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  if (widget.images.length == 1) const SizedBox(width: 8),
                  if (widget.images.length > 1)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _currentPage > 0
                              ? () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _currentPage > 0
                                  ? const Color(0xFF007AFF)
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                              boxShadow: _currentPage > 0
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF007AFF,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: _currentPage > 0
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _currentPage < widget.images.length - 1
                              ? () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _currentPage < widget.images.length - 1
                                  ? const Color(0xFF007AFF)
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                              boxShadow: _currentPage < widget.images.length - 1
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF007AFF,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: _currentPage < widget.images.length - 1
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
