import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../controller/home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Selected Date: ${controller.selectedDate.year}-${controller.selectedDate.month}-${controller.selectedDate.day}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate,
                          firstDate: DateTime(1995, 6, 16),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.updateDate(picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: controller.fetchNasaImage,
                  child: const Text('Get Image'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.imageUrl.value != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              controller.imageUrl.value!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                            ),
                          )
                          : const Center(child: Text('No image available')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
