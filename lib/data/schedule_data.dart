import '../models/programme_model.dart';

class ScheduleData {
  static const String hourlyNewsTitle = 'Dzieje się w Beskidach';
  static const String hourlyNewsDesc = 'Serwisy informacyjne o każdej pełnej godzinie (00–23). Rzetelne wiadomości z regionu.';

  static final Map<int, List<ProgrammeItem>> weeklySchedule = {
    // 1 = Poniedziałek
    1: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Niezwykłe historie, reportaże i wspomnienia z kronikarskich archiwów.', dayOfWeek: 1),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Dźwiękowy zapis najciekawszych materiałów i relacji Beskidzkiej TV.', dayOfWeek: 1),
      const ProgrammeItem(time: '04:30', title: 'Bes kitu', description: 'Świeże spojrzenie na wydarzenia kulturalne i społeczne regionu.', dayOfWeek: 1),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Poranny przegląd najciekawszych materiałów wideo z Beskidów.', dayOfWeek: 1),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Humorystyczne, codzienne spojrzenie w gwiazdy z przymrużeniem oka.', dayOfWeek: 1),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Praktyczne porady i podpowiedzi na codzienne wyzwania.', dayOfWeek: 1),
      const ProgrammeItem(time: '11:10', title: 'Bes kitu', description: 'Południowe wydanie audycji autorskiej.', dayOfWeek: 1),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Druga odsłona kosmicznych przepowiedni na dobry humor.', dayOfWeek: 1),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Fascynujące retrospekcje z życia Bielska-Białej i okolic.', dayOfWeek: 1),
      const ProgrammeItem(time: '14:05', title: 'Opowieści Strasznej Treści', description: 'Legendy, tajemnice i mroczne opowieści z beskidzkich szlaków.', dayOfWeek: 1),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Wywiady z autorami, recenzje nowości wydawniczych i polecenia lektur.', dayOfWeek: 1),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Najlepsza wieczorna selekcja muzyczna dla nocnych marków.', dayOfWeek: 1),
      const ProgrammeItem(time: '22:30', title: 'Życie bez końca', description: 'Nocne rozmowy o filozofii, pasjach i sensie życia.', dayOfWeek: 1),
    ],

    // 2 = Wtorek
    2: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Niezwykłe historie, reportaże i wspomnienia z kronikarskich archiwów.', dayOfWeek: 2),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Dźwiękowy zapis najciekawszych materiałów i relacji Beskidzkiej TV.', dayOfWeek: 2),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Poranny przegląd najciekawszych materiałów wideo z Beskidów.', dayOfWeek: 2),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Humorystyczne, codzienne spojrzenie w gwiazdy.', dayOfWeek: 2),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Praktyczne porady i podpowiedzi na codzienne wyzwania.', dayOfWeek: 2),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Kosmiczne przepowiednie na dobry nastrój.', dayOfWeek: 2),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Fascynujące retrospekcje z życia regionu.', dayOfWeek: 2),
      const ProgrammeItem(time: '14:05', title: 'Redaktor w podróży', description: 'Wyprawy, ciekawostki turystyczne i relacje z bliskich i dalekich szlaków.', dayOfWeek: 2),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Wywiady z pisarzami i rekomendacje literackie.', dayOfWeek: 2),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Świetne beskidzkie rytmy na wieczór.', dayOfWeek: 2),
    ],

    // 3 = Środa
    3: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Niezwykłe historie, reportaże i wspomnienia.', dayOfWeek: 3),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Materiały i relacje Beskidzkiej TV.', dayOfWeek: 3),
      const ProgrammeItem(time: '04:30', title: 'Bes kitu', description: 'Świeże spojrzenie na wydarzenia w regionie.', dayOfWeek: 3),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Poranny przegląd najciekawszych materiałów wideo.', dayOfWeek: 3),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Dobra dawka porannego humoru.', dayOfWeek: 3),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Praktyczne porady życiowe.', dayOfWeek: 3),
      const ProgrammeItem(time: '11:10', title: 'Bes kitu', description: 'Południowe wydanie audycji.', dayOfWeek: 3),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Przepowiednie na popołudnie.', dayOfWeek: 3),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Archiwalne perełki prasowe.', dayOfWeek: 3),
      const ProgrammeItem(time: '14:05', title: 'Ikony popkultury', description: 'Sylwetki legend muzyki, kina i estrady, które ukształtowały pokolenia.', dayOfWeek: 3),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Literatura na wieczór.', dayOfWeek: 3),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Wieczorna energetyczna dawka muzyki.', dayOfWeek: 3),
    ],

    // 4 = Czwartek
    4: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Niezwykłe historie z regionu.', dayOfWeek: 4),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Materiały i wywiady Beskidzkiej TV.', dayOfWeek: 4),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Dźwiękowe relacje wideo.', dayOfWeek: 4),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Poranny horoskop z uśmiechem.', dayOfWeek: 4),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Niezastąpione porady dla każdego.', dayOfWeek: 4),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Gwiazdy o Twoim dniu.', dayOfWeek: 4),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Wspomnienia z Kroniki Beskidzkiej.', dayOfWeek: 4),
      const ProgrammeItem(time: '14:05', title: 'Opowieści Strasznej Treści', description: 'Zagadki kryminalne i tajemnicze opowieści.', dayOfWeek: 4),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Nowości wydawnicze i autorzy.', dayOfWeek: 4),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Mocne brzmienia przed weekendem.', dayOfWeek: 4),
    ],

    // 5 = Piątek
    5: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Niezwykłe opowieści z regionu.', dayOfWeek: 5),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Relacje reporterskie Beskidzkiej TV.', dayOfWeek: 5),
      const ProgrammeItem(time: '04:30', title: 'Bes kitu', description: 'Piątkowy poranek z audycją autorską.', dayOfWeek: 5),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Piątkowe relacje z Podbeskidzia.', dayOfWeek: 5),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Przepowiednie na nadchodzący weekend.', dayOfWeek: 5),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Weekendowe inspiracje i porady.', dayOfWeek: 5),
      const ProgrammeItem(time: '11:10', title: 'Bes kitu', description: 'Południowe spojrzenie na kulturę.', dayOfWeek: 5),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Horoskop na weekend.', dayOfWeek: 5),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Kronikarskie archiwum BGM.', dayOfWeek: 5),
      const ProgrammeItem(time: '14:05', title: 'Redaktor w podróży', description: 'Weekendowe wyprawy i szlaki Beskidów.', dayOfWeek: 5),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Książka idealna na weekend.', dayOfWeek: 5),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Muzyczny start w weekend.', dayOfWeek: 5),
      const ProgrammeItem(time: '22:30', title: 'Życie bez końca', description: 'Spokojna nocna audycja autorska.', dayOfWeek: 5),
    ],

    // 6 = Sobota
    6: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Sobotnia podróż do przeszłości regionu.', dayOfWeek: 6),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Najciekawsze materiały minionego tygodnia.', dayOfWeek: 6),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Sobotni poranek z Beskidzką TV.', dayOfWeek: 6),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Sobotni horoskop na luzie.', dayOfWeek: 6),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Praktyczne patenty domowe i rekreacyjne.', dayOfWeek: 6),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Druga część horoskopu.', dayOfWeek: 6),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Dawne Bielsko i Beskidy w opowieściach.', dayOfWeek: 6),
      const ProgrammeItem(time: '14:05', title: 'Ikony popkultury', description: 'Niezapomniane przeboje i gwiazdy.', dayOfWeek: 6),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Lektury do poduszki.', dayOfWeek: 6),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Sobotnia noc z najlepszą muzyką.', dayOfWeek: 6),
    ],

    // 7 = Niedziela
    7: [
      const ProgrammeItem(time: '02:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Nocne opowieści z archiwum.', dayOfWeek: 7),
      const ProgrammeItem(time: '03:20', title: 'Z Beskidzkiej TV', description: 'Podsumowania wydarzeń regionalnych.', dayOfWeek: 7),
      const ProgrammeItem(time: '04:30', title: 'Bes kitu', description: 'Niedzielny poranek autorski.', dayOfWeek: 7),
      const ProgrammeItem(time: '08:15', title: 'Z Beskidzkiej TV', description: 'Dobre wejście w niedzielę.', dayOfWeek: 7),
      const ProgrammeItem(time: '09:30', title: 'Horoskopy bez wtopy', description: 'Niedzielne wróżby z humorem.', dayOfWeek: 7),
      const ProgrammeItem(time: '10:30', title: 'Wujek Dobra Rada', description: 'Spokojne niedzielne wskazówki.', dayOfWeek: 7),
      const ProgrammeItem(time: '11:10', title: 'Bes kitu', description: 'Kultura i życie regionu.', dayOfWeek: 7),
      const ProgrammeItem(time: '11:30', title: 'Horoskopy bez wtopy', description: 'Przepowiednie na nowy tydzień.', dayOfWeek: 7),
      const ProgrammeItem(time: '12:30', title: 'Z archiwum Kroniki Beskidzkiej', description: 'Złote karty historii Beskidów.', dayOfWeek: 7),
      const ProgrammeItem(time: '14:05', title: 'Ikony popkultury', description: 'Muzyczne wspomnienia i wielkie gwiazdy.', dayOfWeek: 7),
      const ProgrammeItem(time: '19:05', title: 'Strefa dobrej książki', description: 'Książka na koniec tygodnia.', dayOfWeek: 7),
      const ProgrammeItem(time: '20:10', title: 'Gramy nie śpimy', description: 'Wieczorny relaks z Radiem BB.', dayOfWeek: 7),
      const ProgrammeItem(time: '22:30', title: 'Życie bez końca', description: 'Filozoficzne zakończenie weekendu.', dayOfWeek: 7),
    ],
  };

  static String getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'Poniedziałek';
      case 2: return 'Wtorek';
      case 3: return 'Środa';
      case 4: return 'Czwartek';
      case 5: return 'Piątek';
      case 6: return 'Sobota';
      case 7: return 'Niedziela';
      default: return '';
    }
  }

  static String getDayShortName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'Pn';
      case 2: return 'Wt';
      case 3: return 'Śr';
      case 4: return 'Czw';
      case 5: return 'Pt';
      case 6: return 'Sob';
      case 7: return 'Nd';
      default: return '';
    }
  }

  static ProgrammeItem? getCurrentOrNextProgramme() {
    final now = DateTime.now();
    final todayList = weeklySchedule[now.weekday] ?? [];
    final currentMinutes = now.hour * 60 + now.minute;

    ProgrammeItem? current;
    for (int i = 0; i < todayList.length; i++) {
      final prog = todayList[i];
      if (prog.totalMinutes <= currentMinutes) {
        current = prog;
      } else {
        break;
      }
    }
    return current ?? (todayList.isNotEmpty ? todayList.first : null);
  }
}
