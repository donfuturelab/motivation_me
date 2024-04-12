import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../core/ultils/helpers/convert_datetime.dart';
import 'reminder_controller.dart';

class RemiderBottomSheet extends GetView<ReminderController> {
  const RemiderBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          centerTitle: true,
          title: Text('Reminders', style: context.textTheme.displayLarge),
          elevation: 0,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: AppColors.textColor,
              )),
          actions: [
            TextButton(
                onPressed: () {
                  controller.onSaveReminder();
                  Get.back();
                },
                child: Text(
                  'Save',
                  style: context.textTheme.displayMedium
                      ?.copyWith(color: AppColors.main),
                )),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Times per day',
                            style: context.textTheme.displayMedium),
                        const Spacer(),
                        IconButton(
                          onPressed: () => controller.decreaseTimePerDay(),
                          icon: const CircleAvatar(
                            backgroundColor: AppColors.textColor,
                            child: Icon(
                              Icons.remove,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Obx(() => Text('${controller.timePerDay}x',
                                textAlign: TextAlign.center,
                                style: context.textTheme.displayMedium))),
                        IconButton(
                          onPressed: () => controller.increaseTimePerDay(),
                          icon: const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.textColor,
                            child: Icon(
                              Icons.add,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Start at',
                            style: context.textTheme.displayMedium),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                minuteInterval: TimePickerInterval.FIFTEEN,
                                value: controller.startTime,
                                onChange: (value) =>
                                    controller.changeStartTime(value),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.middleBlack,
                                borderRadius: BorderRadius.circular(10)),
                            child: Obx(() => SizedBox(
                                  width: 100,
                                  child: Text(
                                      timeToString12(controller.startTime),
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.displayMedium),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('End at', style: context.textTheme.displayMedium),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            showPicker(
                              context: context,
                              minuteInterval: TimePickerInterval.FIFTEEN,
                              value: controller.endTime,
                              onChange: (value) =>
                                  controller.changeEndTime(value),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.middleBlack,
                                borderRadius: BorderRadius.circular(10)),
                            child: Obx(() => SizedBox(
                                  width: 100,
                                  child: Text(
                                      timeToString12(controller.endTime),
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.displayMedium),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 1,
                      color: AppColors.middleBlack,
                    ),
                    const SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Repeat',
                            style: context.textTheme.displayMedium)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var i = 1; i < 8; i++)
                          GestureDetector(
                            onTap: () => controller.toggleReminderDay(i),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(() => Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.textColor,
                                        ),
                                        color:
                                            controller.reminderDays.contains(i)
                                                ? AppColors.textColor
                                                : AppColors.black),
                                    child: Text(indexToDayOfWeek(i),
                                        style: context.textTheme.displayMedium!
                                            .copyWith(
                                                color: controller.reminderDays
                                                        .contains(i)
                                                    ? AppColors.black
                                                    : AppColors.textColor)),
                                  )),
                            ),
                          ),
                      ],
                    )
                  ],
                )),
          ),
        ));
  }
}
