import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/schedule_data.dart';
import '../models/programme_model.dart';
import '../theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    // Domyślnie zaznacz bieżący dzień tygodnia (1 = Pn, 7 = Nd)
    _selectedDay = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    final programmes = ScheduleData.weeklySchedule[_selectedDay] ?? [];
    final now = DateTime.now();
    final isToday = now.weekday == _selectedDay;
    final currentMinutes = now.hour * 60 + now.minute;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ramówka Radia BB',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: Column(
        children: [
          // Pasek wyboru dnia tygodnia (Pn - Nd)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppTheme.navyPrimary,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(7, (index) {
                  final dayNum = index + 1;
                  final isSelected = dayNum == _selectedDay;
                  final isCurrentDay = dayNum == now.weekday;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isCurrentDay) ...[
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.amberAccent,
                              ),
                            ),
                          ],
                          Text(ScheduleData.getDayShortName(dayNum)),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.bluePrimary,
                      backgroundColor: AppTheme.navyCard,
                      labelStyle: GoogleFonts.jetbrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppTheme.paperWhite : AppTheme.textLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.bluePrimary
                              : (isCurrentDay ? AppTheme.amberAccent : AppTheme.navyCardLight),
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedDay = dayNum;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // Pasek informacyjny o cogodzinnych serwisach informacyjnych
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.navyCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.bluePrimary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppTheme.bluePrimary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(fontSize: 12.5, color: AppTheme.textLight),
                      children: [
                        TextSpan(
                          text: 'Dzieje się w Beskidach: ',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.paperWhite,
                          ),
                        ),
                        const TextSpan(
                          text: 'serwis informacyjny o każdej pełnej godzinie (00–23).',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista audycji na dany dzień
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: programmes.length,
              itemBuilder: (context, index) {
                final prog = programmes[index];
                final nextProg = index + 1 < programmes.length ? programmes[index + 1] : null;

                // Sprawdzamy czy audycja trwa w tym momencie
                final isLiveNow = isToday &&
                    prog.totalMinutes <= currentMinutes &&
                    (nextProg == null || nextProg.totalMinutes > currentMinutes);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isLiveNow ? AppTheme.navyCardLight : AppTheme.navyCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLiveNow
                          ? AppTheme.amberAccent
                          : AppTheme.navyCardLight.withOpacity(0.5),
                      width: isLiveNow ? 1.5 : 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Godzina audycji
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isLiveNow
                                ? AppTheme.amberAccent.withOpacity(0.2)
                                : AppTheme.navyPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            prog.time,
                            style: GoogleFonts.jetbrainsMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isLiveNow ? AppTheme.amberAccent : AppTheme.blueSoft,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Tytuł i opis audycji
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      prog.title,
                                      style: GoogleFonts.manrope(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.paperWhite,
                                      ),
                                    ),
                                  ),
                                  if (isLiveNow) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppTheme.amberAccent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'TERAZ',
                                        style: GoogleFonts.jetbrainsMono(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.navyDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (prog.description.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  prog.description,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
