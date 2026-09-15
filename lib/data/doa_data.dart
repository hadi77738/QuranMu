import '../models/doa.dart';

class DoaData {
  static const List<DoaItem> listDoa = [
    DoaItem(
      id: 1,
      judul: 'Doa Bangun Tidur',
      kategori: 'Harian',
      teksArab: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      teksLatin: 'Alhamdulillaahil-ladzii ahyaanaa ba\'da maa amaatanaa wa ilaihin-nusyuur.',
      arti: 'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami dan kepada-Nya kami dibangkitkan.',
      riwayat: 'HR. Bukhari no. 6312 & Muslim no. 2711',
    ),
    DoaItem(
      id: 2,
      judul: 'Doa Sebelum Tidur',
      kategori: 'Harian',
      teksArab: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      teksLatin: 'Bismikallaahumma amuutu wa ahyaa.',
      arti: 'Dengan nama-Mu ya Allah, aku mati dan aku hidup.',
      riwayat: 'HR. Bukhari no. 6324',
    ),
    DoaItem(
      id: 3,
      judul: 'Doa Sebelum Makan',
      kategori: 'Harian',
      teksArab: 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ ، بِسْمِ اللَّهِ',
      teksLatin: 'Allaahumma baarik lanaa fiimaa razaqtanaa waqinaa \'adzaaban-naar, bismillaah.',
      arti: 'Ya Allah, berkahilah kami dalam rezeki yang telah Engkau limpahkan kepada kami dan peliharalah kami dari siksa api neraka. Dengan nama Allah.',
      riwayat: 'HR. Ibnu Sunni no. 457',
    ),
    DoaItem(
      id: 4,
      judul: 'Doa Setelah Makan',
      kategori: 'Harian',
      teksArab: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
      teksLatin: 'Alhamdulillaahil-ladzii ath\'amanaa wa saqaanaa wa ja\'alanaa muslimiin.',
      arti: 'Segala puji bagi Allah yang memberi kami makan dan minum serta menjadikan kami termasuk orang-orang muslim.',
      riwayat: 'HR. Abu Dawud no. 3850 & Tirmidzi no. 3457',
    ),
    DoaItem(
      id: 5,
      judul: 'Doa Masuk Masjid',
      kategori: 'Ibadah',
      teksArab: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      teksLatin: 'Allaahummaftah lii abwaaba rahmatik.',
      arti: 'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.',
      riwayat: 'HR. Muslim no. 713',
    ),
    DoaItem(
      id: 6,
      judul: 'Doa Keluar Masjid',
      kategori: 'Ibadah',
      teksArab: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
      teksLatin: 'Allaahumma innii as-aluka min fadlik.',
      arti: 'Ya Allah, sesungguhnya aku memohon keutamaan dari karunia-Mu.',
      riwayat: 'HR. Muslim no. 713',
    ),
    DoaItem(
      id: 7,
      judul: 'Doa Keluar Rumah',
      kategori: 'Perjalanan',
      teksArab: 'بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ ، لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      teksLatin: 'Bismillaahi tawakkaltu \'alallaahi, laa hawla wa laa quwwata illaa billaah.',
      arti: 'Dengan nama Allah, aku bertawakal kepada Allah. Tiada daya dan kekuatan kecuali dengan pertolongan Allah.',
      riwayat: 'HR. Abu Dawud no. 5095 & Tirmidzi no. 3426',
    ),
    DoaItem(
      id: 8,
      judul: 'Doa Naik Kendaraan',
      kategori: 'Perjalanan',
      teksArab: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ',
      teksLatin: 'Subhaanal-ladzii sakh-khara lanaa haadzaa wa maa kunnaa lahuu muqriniin, wa innaa ilaa rabbinaa lamunqalibuun.',
      arti: 'Maha Suci Tuhan yang telah menundukkan semua ini bagi kami padahal kami sebelumnya tidak mampu menguasainya, dan sesungguhnya kami akan kembali kepada Tuhan kami.',
      riwayat: 'QS. Az-Zukhruf: 13-14 / HR. Muslim no. 1342',
    ),
    DoaItem(
      id: 9,
      judul: 'Doa untuk Kedua Orang Tua',
      kategori: 'Harian',
      teksArab: 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      teksLatin: 'Rabbighfir lii wa liwaalidayya warhamhumaa kamaa rabbayaanii shaghiiraa.',
      arti: 'Wahai Tuhanku, ampunilah aku dan kedua orang tuaku, dan sayangilah mereka berdua sebagaimana mereka telah mendidikku pada waktu kecil.',
      riwayat: 'QS. Al-Isra\': 24',
    ),
    DoaItem(
      id: 10,
      judul: 'Doa Sapu Jagad (Kebaikan Dunia & Akhirat)',
      kategori: 'Harian',
      teksArab: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      teksLatin: 'Rabbanaa aatinaa fid-dunyaa hasanah wa fil-aakhirati hasanah wa qinaa \'adzaaban-naar.',
      arti: 'Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat dan lindungilah kami dari siksa api neraka.',
      riwayat: 'QS. Al-Baqarah: 201',
    ),
    DoaItem(
      id: 11,
      judul: 'Sayyidul Istighfar',
      kategori: 'Dzikir',
      teksArab: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ ، خَلَقْتَنِي وَأَنَا عَبْدُكَ ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      teksLatin: 'Allaahumma anta Rabbii laa ilaaha illaa Anta, khalaqtanii wa anaa \'abduka, wa anaa \'alaa \'ahdika wa wa\'dika mastatha\'tu, a\'uudzu bika min syarri maa shana\'tu, abuu-u laka bini\'matika \'alayya, wa abuu-u laka bidzanbii faghfir lii fa-innahu laa yaghfirudz-dzunuuba illaa Anta.',
      arti: 'Ya Allah, Engkau adalah Tuhanku, tidak ada Tuhan yang berhak disembah selain Engkau. Engkau yang menciptakan aku dan aku adalah hamba-Mu. Aku memegang perjanjian-Mu sekuat kemampuanku. Aku berlindung kepada-Mu dari keburukan apa yang kuperbuat. Aku mengakui segala nikmat-Mu kepadaku dan aku mengakui dosaku kepada-Mu, maka ampunilah aku, sesungguhnya tidak ada yang mengampuni dosa selain Engkau.',
      riwayat: 'HR. Bukhari no. 6306',
    ),
    DoaItem(
      id: 12,
      judul: 'Dzikir Perlindungan Pagi & Petang',
      kategori: 'Dzikir',
      teksArab: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      teksLatin: 'Bismillaahil-ladzii laa yadhurru ma\'asmihii syai-un fil-ardhi wa laa fis-samaa-i wa huwas-samii\'ul-\'aliim. (3x)',
      arti: 'Dengan nama Allah yang bila bersama nama-Nya, tidak ada sesuatu pun di bumi dan di langit yang dapat mendatangkan bahaya, dan Dia Maha Mendengar lagi Maha Mengetahui.',
      riwayat: 'HR. Abu Dawud no. 5088 & Tirmidzi no. 3388',
    ),

    // ==========================================
    // BAGIAN 1: DOA SETELAH SELESAI SHOLAT
    // ==========================================
    DoaItem(
      id: 13,
      judul: 'Doa Setelah Selesai Sholat Fardhu',
      kategori: 'Setelah Sholat',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\n\n'
          'اَلْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِيْنَ. حَمْدًا شَاكِرِيْنَ، حَمْدًا نَاعِمِيْنَ، حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ.\n\n'
          'يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَعَظِيْمِ سُلْطَانِكَ.\n\n'
          'اَللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ.\n\n'
          'اَللَّهُمَّ إِنَّا نَسْأَلُكَ سَلَامَةً فِى الدِّيْنِ، وَعَافِيَةً فِى الْجَسَدِ، وَزِيَادَةً فِى الْعِلْمِ، وَبَرَكَةً فِى الرِّزْقِ، وَتَوْبَةً قَبْلَ الْمَوْتِ، وَرَحْمَةً عِنْدَ الْمَوْتِ، وَمَغْفِرَةً بَعْدَ الْمَوْتِ.\n\n'
          'اَللَّهُمَّ هَوِّنْ عَلَيْنَا فِيْ سَكَرَاتِ الْمَوْتِ، وَالنَّجَاةَ مِنَ النَّارِ، وَالْعَفْوَ عِنْدَ الْحِسَابِ.\n\n'
          'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ الْخَاسِرِيْنَ.\n\n'
          'رَبَّنَا لَا تُزِغْ قُلُوْبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ.\n\n'
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِيْنَ إِمَامًا.\n\n'
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.\n\n'
          'وَصَلَّى اللَّهُ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ وَسَلَّمَ.\n\n'
          'سُبْحَانَ رَبِّكَ رَبِّ الْعِزَّةِ عَمَّا يَصِفُوْنَ، وَسَلَامٌ عَلَى الْمُرْسَلِيْنَ، وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِيْنَ.',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim.\n'
          'Al-hamdu lillaahi rabbil-\'aalamiin. Hamdasy-syaakiriin, hamdan-naa\'imiin, hamday-yuwaafii ni\'amahuu wa yukaafi-u maziidah.\n'
          'Yaa rabbanaa lakal-hamdu kamaa yambaghii lijalaali wajhika wa \'azhiimi sulthaanik.\n'
          'Allaahumma shalli wa sallim \'alaa sayyidinaa Muhammadin wa \'alaa aali sayyidinaa Muhammad.\n'
          'Allaahumma innaa nas-aluka salaamatan fid-diin, wa \'aafiyatan fil-jasad, wa ziyaadatan fil-\'ilm, wa barakatan fir-rizq, wa taubatan qablal-maut, wa rahmatan \'indal-maut, wa maghfiratam ba\'dal-maut.\n'
          'Allaahumma hawwin \'alainaa fii sakaraatil-maut, wan-najaata minan-naar, wal-\'afwa \'indal-hisaab.\n'
          'Rabbanaa zhalamnaa anfusanaa wa illam taghfir lanaa wa tarhamnaa lanakuunanna minal-khaasiriin.\n'
          'Rabbanaa laa tuzigh quluubanaa ba\'da idz hadaitanaa wa hab lanaa mil-ladunka rahmah, innaka antal-wahhaab.\n'
          'Rabbanaa hab lanaa min azwaajinaa wa dzurriyyaatinaa qurrata a\'yun, waj\'alnaa lil-muttaqiina imaamaa.\n'
          'Rabbanaa aatinaa fid-dunyaa hasanah, wa fil-aakhirati hasanah, wa qinaa \'adzaaban-naar.\n'
          'Wa shallallaahu \'alaa sayyidinaa Muhammadin wa \'alaa aalihii wa ash-haabihii wa sallam.\n'
          'Subhaana rabbika rabbil-\'izzati \'ammaa yashifuun, wa salaamun \'alal-mursaliin, wal-hamdu lillaahi rabbil-\'aalamiin.',
      arti: '• Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang.\n'
          '• Segala puji bagi Allah Tuhan semesta alam. Pujian orang-orang yang bersyukur, pujian orang-orang yang mendapat nikmat, pujian yang memadai nikmat-Nya dan menyamai tambahannya.\n'
          '• Wahai Tuhan kami, bagi-Mu segala puji sebagaimana layaknya bagi keagungan Dzat-Mu dan kebesaran kekuasaan-Mu.\n'
          '• Ya Allah, limpahkanlah rahmat dan keselamatan kepada junjungan kami Nabi Muhammad dan kepada keluarga junjungan kami Nabi Muhammad.\n'
          '• Ya Allah, sesungguhnya kami memohon kepada-Mu keselamatan dalam agama, kesehatan dalam tubuh, tambahan dalam ilmu, keberkahan dalam rezeki, taubat sebelum mati, rahmat ketika mati, dan ampunan setelah mati.\n'
          '• Ya Allah, ringankanlah kami dalam menghadapi sakaratul maut, selamatkanlah kami dari siksa neraka, dan ampunilah kami pada saat hisab (perhitungan amal).\n'
          '• Ya Tuhan kami, kami telah menzalimi diri kami sendiri. Jika Engkau tidak mengampuni kami dan memberi rahmat kepada kami, niscaya kami termasuk orang-orang yang rugi.\n'
          '• Ya Tuhan kami, janganlah Engkau condongkan hati kami kepada kesesatan setelah Engkau berikan petunjuk kepada kami, dan karuniakanlah rahmat dari sisi-Mu kepada kami, sesungguhnya Engkau Maha Pemberi.\n'
          '• Ya Tuhan kami, anugerahkanlah kepada kami pasangan kami dan keturunan kami sebagai penyenang hati, dan jadikanlah kami pemimpin bagi orang-orang yang bertakwa.\n'
          '• Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat, dan lindungilah kami dari azab neraka.\n'
          '• Semoga Allah melimpahkan rahmat dan kesejahteraan kepada junjungan kami Nabi Muhammad, beserta keluarga dan para sahabatnya.\n'
          '• Maha Suci Tuhanmu, Tuhan Yang Maha Perkasa dari apa yang mereka sifatkan. Dan kesejahteraan dilimpahkan atas para rasul. Dan segala puji bagi Allah Tuhan semesta alam.',
      riwayat: 'Doa Ma\'tsur Ba\'da Sholat Fardhu',
    ),

    // ==========================================
    // BAGIAN 2: SUSUNAN BACAAN TAHLIL (17 URUTAN)
    // ==========================================
    DoaItem(
      id: 101,
      urutan: 1,
      judul: '1. Pengantar Al-Fatihah (Tawasul)',
      kategori: 'Tahlil',
      teksArab: 'إِلَى حَضْرَةِ النَّبِيِّ الْمُصْطَفَى مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَاَلِهِ وَصَحْبِهِ شَيْءٌ لِلَّهِ لَهُمُ الْفَاتِحَةُ',
      teksLatin: 'Ilaa hadhratin-nabiyyil-mushthafaa Muhammadin shallallaahu \'alaihi wa sallam wa aalihii wa shahbihii syai-ul lillaahi lahumul-faatihah.',
      arti: 'Kepada yang mulia Nabi pilihan Muhammad SAW, keluarga dan sahabatnya, sesuatu karena Allah untuk mereka: Al-Fatihah.',
      riwayat: 'Susunan Bacaan Tahlil ke-1 (Tawasul)',
    ),
    DoaItem(
      id: 102,
      urutan: 2,
      judul: '2. Surat Al-Fatihah',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ. الرَّحْمَنِ الرَّحِيمِ. مَالِكِ يَوْمِ الدِّينِ. إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ. اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ. صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ. أَمِين',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Al-hamdu lillaahi rabbil-\'aalamiin. Ar-rahmaanir-rahiim. Maaliki yaumid-diin. Iyyaaka na\'budu wa iyyaaka nasta\'iin. Ihdinash-shiraathal-mustaqiim. Shiraathal-ladziina an\'amta \'alaihim ghairil-maghdhuubi \'alaihim waladh-dhaalliin. Aamiin.',
      arti: 'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah, Tuhan seluruh alam. Yang Maha Pengasih, Maha Penyayang. Pemilik hari pembalasan. Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan. Tunjukilah kami jalan yang lurus, (yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.',
      riwayat: 'Susunan Bacaan Tahlil ke-2',
    ),
    DoaItem(
      id: 103,
      urutan: 3,
      count: 3,
      judul: '3. Surat Al-Ikhlas (Dibaca 3x)',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ هُوَ اللَّهُ أَحَدٌ. اللَّهُ الصَّمَدُ. لَمْ يَلِدْ وَلَمْ يُولَدْ. وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Qul huwallaahu ahad. Allaahush-shamad. Lam yalid wa lam yuulad. Wa lam yakul-lahuu kufuwan ahad. (Dibaca 3x)',
      arti: 'Katakanlah: Dialah Allah, Yang Maha Esa. Allah tempat meminta segala sesuatu. Allah tidak beranak dan tidak pula diperanakkan. Dan tidak ada sesuatu yang setara dengan Dia.',
      riwayat: 'Susunan Bacaan Tahlil ke-3 (Dibaca 3x)',
    ),
    DoaItem(
      id: 104,
      urutan: 4,
      judul: '4. Tahlil dan Takbir',
      kategori: 'Tahlil',
      teksArab: 'لَا إِلَهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
      teksLatin: 'Laa ilaaha illallaahu wallaahu akbar.',
      arti: 'Tiada Tuhan selain Allah dan Allah Maha Besar.',
      riwayat: 'Susunan Bacaan Tahlil ke-4',
    ),
    DoaItem(
      id: 105,
      urutan: 5,
      judul: '5. Surat Al-Falaq',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ. مِنْ شَرِّ مَا خَلَقَ. وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ. وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ. وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Qul a\'uudzu birabbil-falaq. Min syarri maa khalaq. Wa min syarri ghaasiqin idzaa waqab. Wa min syarrin-naffaatsaati fil-\'uqad. Wa min syarri haasidin idzaa hasad.',
      arti: 'Katakanlah: Aku berlindung kepada Tuhan yang menguasai subuh (fajar), dari kejahatan makhluk yang Dia ciptakan, dan dari kejahatan malam apabila telah gelap gulita, dan dari kejahatan perempuan-perempuan penyihir yang meniup pada buhul-buhul (talinya), dan dari kejahatan orang yang dengki apabila dia dengki.',
      riwayat: 'Susunan Bacaan Tahlil ke-5',
    ),
    DoaItem(
      id: 106,
      urutan: 6,
      judul: '6. Tahlil dan Takbir',
      kategori: 'Tahlil',
      teksArab: 'لَا إِلَهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
      teksLatin: 'Laa ilaaha illallaahu wallaahu akbar.',
      arti: 'Tiada Tuhan selain Allah dan Allah Maha Besar.',
      riwayat: 'Susunan Bacaan Tahlil ke-6',
    ),
    DoaItem(
      id: 107,
      urutan: 7,
      judul: '7. Surat An-Nas',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ أَعُوذُ بِرَبِّ النَّاسِ. مَلِكِ النَّاسِ. إِلَهِ النَّاسِ. مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ. الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ. مِنَ الْجِنَّةِ وَالنَّاسِ',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Qul a\'uudzu birabbin-naas. Malikin-naas. Ilaahin-naas. Min syarril-waswaasil-khannaas. Alladzii yuwaswisu fii shuduurin-naas. Minal-jinnati wan-naas.',
      arti: 'Katakanlah: Aku berlindung kepada Tuhannya manusia, Raja manusia, Sembahan manusia, dari kejahatan (bisikan) setan yang bersembunyi, yang membisikkan (kejahatan) ke dalam dada manusia, dari (golongan) jin dan manusia.',
      riwayat: 'Susunan Bacaan Tahlil ke-7',
    ),
    DoaItem(
      id: 108,
      urutan: 8,
      judul: '8. Tahlil dan Takbir',
      kategori: 'Tahlil',
      teksArab: 'لَا إِلَهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
      teksLatin: 'Laa ilaaha illallaahu wallaahu akbar.',
      arti: 'Tiada Tuhan selain Allah dan Allah Maha Besar.',
      riwayat: 'Susunan Bacaan Tahlil ke-8',
    ),
    DoaItem(
      id: 109,
      urutan: 9,
      judul: '9. Surat Al-Fatihah',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ. الرَّحْمَنِ الرَّحِيمِ. مَالِكِ يَوْمِ الدِّينِ. إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ. اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ. صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ. أَمِين',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Al-hamdu lillaahi rabbil-\'aalamiin. Ar-rahmaanir-rahiim. Maaliki yaumid-diin. Iyyaaka na\'budu wa iyyaaka nasta\'iin. Ihdinash-shiraathal-mustaqiim. Shiraathal-ladziina an\'amta \'alaihim ghairil-maghdhuubi \'alaihim waladh-dhaalliin. Aamiin.',
      arti: 'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah Tuhan seluruh alam...',
      riwayat: 'Susunan Bacaan Tahlil ke-9',
    ),
    DoaItem(
      id: 110,
      urutan: 10,
      judul: '10. Awal Surat Al-Baqarah',
      kategori: 'Tahlil',
      teksArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. الم. ذَلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ. الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنْفِقُونَ. وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنْزِلَ إِلَيْكَ وَمَا أُنْزِلَ مِنْ قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ. أُولَئِكَ عَلَى هُدًى مِنْ رَبِّهِمْ وَأُولَئِكَ هُمُ الْمُفْلِحُونَ',
      teksLatin: 'Bismillaahir-rahmaanir-rahiim. Alif-laam-miim. Dzaalikal-kitaabu laa raiba fiihi hudal-lil-muttaqiin. Alladziina yu\'minuuna bil-ghaibi wa yuqiimuunash-shalaata wa mimmaa razaqnaahum yunfiquun. Walladziina yu\'minuuna bimaa unzila ilaika wa maa unzila min qablika wa bil-aakhirati hum yuuqinuun. Ulaa-ika \'alaa hudam-mir-rabbihim wa ulaa-ika humul-muflihuun.',
      arti: 'Alif Laam Miim. Kitab (Al-Qur\'an) ini tidak ada keraguan padanya; petunjuk bagi mereka yang bertakwa. (Yaitu) mereka yang beriman kepada yang gaib, melaksanakan salat, dan menginfakkan sebagian rezeki yang Kami berikan kepada mereka. Dan mereka yang beriman kepada (Al-Qur\'an) yang diturunkan kepadamu dan kitab-kitab yang telah diturunkan sebelum engkau, serta mereka yakin akan adanya akhirat. Merekalah yang mendapat petunjuk dari Tuhannya, dan mereka itulah orang-orang yang beruntung.',
      riwayat: 'Susunan Bacaan Tahlil ke-10 (QS. Al-Baqarah: 1-5)',
    ),
    DoaItem(
      id: 111,
      urutan: 11,
      judul: '11. Ayat Kursi',
      kategori: 'Tahlil',
      teksArab: 'وَإِلَهُكُمْ إِلَهٌ وَاحِدٌ لَا إِلَهَ إِلَّا هُوَ الرَّحْمَنُ الرَّحِيمُ.\n\n'
          'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
      teksLatin: 'Wa ilaahukum ilaahuw waahid, laa ilaaha illaa huwar-rahmaanur-rahiim.\n'
          'Allaahu laa ilaaha illaa huwal-hayyul-qayyuum, laa ta\'khudzuhuu sinatuw wa laa naum, lahuu maa fis-samaawaati wa maa fil-ardh, man dzal-ladzii yasyfa\'u \'indahuu illaa bi-idznih, ya\'lamu maa baina aidiihim wa maa khalfahum, wa laa yuhiithuuna bisyai-im min \'ilmihii illaa bimaa syaa\', wasi\'a kursiyyuhus-samaawaati wal-ardh, wa laa ya-uuduhuu hifzhuhumaa, wa huwal-\'aliyyul-\'azhiim.',
      arti: 'Dan Tuhanmu adalah Tuhan Yang Maha Esa; tidak ada Tuhan melainkan Dia, Yang Maha Pengasih lagi Maha Penyayang. Allah, tidak ada Tuhan selain Dia Yang Hidup kekal lagi terus menerus mengurus (makhluk-Nya); tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan apa yang ada di bumi. Tiada yang dapat memberi syafaat di sisi Allah tanpa izin-Nya. Allah mengetahui apa-apa yang di hadapan mereka dan di belakang mereka, dan mereka tidak mengetahui apa-apa dari ilmu Allah melainkan apa yang dikehendaki-Nya. Kursi Allah meliputi langit dan bumi. Dan Allah tidak merasa berat memelihara keduanya, dan Allah Maha Tinggi lagi Maha Besar.',
      riwayat: 'Susunan Bacaan Tahlil ke-11 (QS. Al-Baqarah: 163 & 255)',
    ),
    DoaItem(
      id: 112,
      urutan: 12,
      count: 3,
      judul: '12. Istighfar (Dibaca 3x)',
      kategori: 'Tahlil',
      teksArab: 'أَسْتَغْفِرُ اللهَ الْعَظِيْمَ',
      teksLatin: 'Astaghfirullaahal-\'azhiim. (Dibaca 3x)',
      arti: 'Aku memohon ampun kepada Allah Yang Maha Agung.',
      riwayat: 'Susunan Bacaan Tahlil ke-12 (Dibaca 3x)',
    ),
    DoaItem(
      id: 113,
      urutan: 13,
      count: 33,
      judul: '13. Inti Tahlil',
      kategori: 'Tahlil',
      teksArab: 'أَفْضَلُ الذِّكْرِ فَاعْلَمْ أَنَّهُ:\n\n'
          'لَا إِلَهَ إِلَّا اللهُ\n\n'
          'لَا إِلَهَ إِلَّا اللهُ مُحَمَّدٌ رَسُوْلُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ',
      teksLatin: 'Afdhaludz-dzikri fa\'lam annahuu:\n'
          'Laa ilaaha illallaah (Dibaca 33x atau 100x)\n'
          'Laa ilaaha illallaahu Muhammadur-rasuulullaahi shallallaahu \'alaihi wa sallam.',
      arti: 'Ketahuilah bahwa sebaik-baik dzikir adalah kalimat: Tiada Tuhan selain Allah. Tiada Tuhan selain Allah, Muhammad utusan Allah semoga Allah memberi rahmat dan keselamatan kepadanya.',
      riwayat: 'Susunan Bacaan Tahlil ke-13 (Dibaca 33x atau 100x)',
    ),
    DoaItem(
      id: 114,
      urutan: 14,
      judul: '14. Shalawat Nabi',
      kategori: 'Tahlil',
      teksArab: 'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ، اللَّهُمَّ صَلِّ عَلَيْهِ وَسَلِّمْ\n\n'
          'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ، يَارَبِّ صَلِّ عَلَيْهِ وَسَلِّمْ',
      teksLatin: 'Allaahumma shalli \'alaa sayyidinaa Muhammad, Allaahumma shalli \'alaihi wa sallim (2x).\n'
          'Allaahumma shalli \'alaa sayyidinaa Muhammad, yaa rabbi shalli \'alaihi wa sallim.',
      arti: 'Ya Allah limpahkanlah shalawat kepada junjungan kami Nabi Muhammad, ya Allah limpahkanlah shalawat dan keselamatan kepadanya (2x). Ya Allah limpahkanlah shalawat kepada junjungan kami Nabi Muhammad, ya Tuhanku limpahkanlah shalawat dan keselamatan kepadanya.',
      riwayat: 'Susunan Bacaan Tahlil ke-14',
    ),
    DoaItem(
      id: 115,
      urutan: 15,
      count: 33,
      judul: '15. Tasbih',
      kategori: 'Tahlil',
      teksArab: 'سُبْحَانَ اللهِ وَبِحَمْدِهِ سُبْحَانَ اللهِ الْعَظِيْمِ',
      teksLatin: 'Subhaanallaahi wa bihamdihii subhaanallaahil-\'azhiim. (Dibaca 33x)',
      arti: 'Maha Suci Allah dan dengan memuji-Nya, Maha Suci Allah Yang Maha Agung.',
      riwayat: 'Susunan Bacaan Tahlil ke-15 (Dibaca 33x)',
    ),
    DoaItem(
      id: 116,
      urutan: 16,
      judul: '16. Doa Tahlil (Doa Arwah)',
      kategori: 'Tahlil',
      teksArab: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيْمِ. الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِيْنَ حَمْدًا الشَّاكِرِيْنَ حَمْدًا النَّاعِمِيْنَ حَمْدًا يُوَافِي نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِي لِجَلَالِ وَجْهِكَ وَعَظِيْمِ سُلْطَانِكَ.\n\n'
          'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ.\n\n'
          'اللَّهُمَّ تَقَبَّلْ وَأَوْصِلْ ثَوَابَ مَا قَرَأْنَاهُ مِنَ الْقُرْآنِ الْعَظِيْمِ وَمَا هَلَّلْنَا وَمَا سَبَّحْنَا وَمَا اسْتَغْفَرْنَا وَمَا صَلَّيْنَا عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ هَدِيَّةً وَاصِلَةً وَرَحْمَةً نَازِلَةً وَبَرَكَةً شَامِلَةً إِلَى حَضْرَةِ حَبِيْبِنَا وَشَفِيْعِنَا وَقُرَّةِ أَعْيُنِنَا سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، وَإِلَى جَمِيْعِ إِخْوَانِهِ مِنَ الْأَنْبِيَاءِ وَالْمُرْسَلِيْنَ وَالْأَوْلِيَاءِ وَالشُّهَدَاءِ وَالصَّالِحِيْنَ وَالصَّحَابَةِ وَالتَّابِعِيْنَ وَالْعُلَمَاءِ الْعَامِلِيْنَ وَالْمُصَنِّفِيْنَ الْمُخْلِصِيْنَ وَجَمِيْعِ الْمُجَاهِدِيْنَ فِي سَبِيْلِ اللهِ رَبِّ الْعَالَمِيْنَ وَالْمَلَائِكَةِ الْمُقَرَّبِيْنَ.\n\n'
          'ثُمَّ إِلَى أَرْوَاحِ جَمِيْعِ أَهْلِ الْقُبُوْرِ مِنَ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ مِنْ مَشَارِقِ الْأَرْضِ إِلَى مَغَارِبِهَا بَرِّهَا وَبَحْرِهَا خُصُوْصًا إِلَى آبَائِنَا وَأُمَّهَاتِنَا وَأَجْدَادِنَا وَجَدَّاتِنَا وَمَشَايِخِنَا وَمَشَايِخِ مَشَايِخِنَا وَأَسَاتِذَتِنَا وَأَسَاتِذَةِ أََسَاتِذَتِنَا وَلِمَنْ أَحْسَنَ إِلَيْنَا وَلِمَنْ اجْتَمَعْنَا هَهُنَا بِسَبَبِهِ.\n\n'
          'اللَّهُمَّ اغْفِرْ لَهُمْ وَارْحَمْهُمْ وَعَافِهِمْ وَاعْفُ عَنْهُمْ.\n\n'
          'اللَّهُمَّ أَنْزِلِ الرَّحْمَةَ وَالْمَغْفِرَةَ عَلَى أَهْلِ الْقُبُوْرِ مِنْ أَهْلِ لَا إِلَهَ إِلَّا اللهُ مُحَمَّدٌ رَسُوْلُ اللهِ.\n\n'
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.\n\n'
          'وَصَلَّى اللهُ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ وَسَلَّمَ، سُبْحَانَ رَبِّكَ رَبِّ الْعِزَّةِ عَمَّا يَصِفُوْنَ، وَسَلَامٌ عَلَى الْمُرْسَلِيْنَ وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِيْنَ.',
      teksLatin: 'A\'uudzu billaahi minasy-syaithaanir-rajiim. Bismillaahir-rahmaanir-rahiim. Al-hamdu lillaahi rabbil-\'aalamiin hamdasy-syaakiriin hamdan-naa\'imiin hamday-yuwaafii ni\'amahuu wa yukaafi-u maziidah, yaa rabbanaa lakal-hamdu kamaa yambaghii lijalaali wajhika wa \'azhiimi sulthaanik.\n\n'
          'Allaahumma shalli wa sallim \'alaa sayyidinaa Muhammadin wa \'alaa aali sayyidinaa Muhammad.\n\n'
          'Allaahumma taqabbal wa aushil tsawaaba maa qara\'naahu minal-qur\'aanil-\'azhiim wa maa hallalnaa wa maa sabbahnaa wa mastaghfarnaa wa maa shallainaa \'alaa sayyidinaa Muhammadin shallallaahu \'alaihi wa sallam hadiyyatan waashilah wa rahmatan naazilah wa barakatan syaamilah ilaa hadhrati habiibinaa wa syafii\'inaa wa qurrati a\'yuninaa sayyidinaa wa maulaanaa Muhammadin shallallaahu \'alaihi wa sallam...\n\n'
          'Tsumma ilaa arwaahi jamii\'i ahlil-qubuuri minal-muslimiina wal-muslimaati wal-mu\'miniina wal-mu\'minaat min masyaariqil-ardhi ilaa maghaaribihaa barrihaa wa bahrihaa khushuushan ilaa aabaa-inaa wa ummahaatinaa wa ajdaadinaa wa jaddaatinaa wa masyaayikhinaa wa masyaayikhi masyaayikhinaa wa asaatidzatinaa wa asaatidzati asaatidzatinaa wa liman ahsana ilainaa wa limanij-tama\'naa haahunaa bisababih.\n\n'
          'Allaahummaghfir lahum warhamhum wa \'aafihim wa\'fu \'anhum. Allaahumma anzilir-rahmata wal-maghfirata \'alaa ahlil-qubuuri min ahli laa ilaaha illallaahu Muhammadur-rasuulullaah.\n\n'
          'Rabbanaa aatinaa fid-dunyaa hasanah wa fil-aakhirati hasanah wa qinaa \'adzaaban-naar.\n\n'
          'Wa shallallaahu \'alaa sayyidinaa Muhammadin wa \'alaa aalihii wa shahbihii wa sallam, subhaana rabbika rabbil-\'izzati \'ammaa yashifuun, wa salaamun \'alal-mursaliin wal-hamdu lillaahi rabbil-\'aalamiin.',
      arti: 'Aku berlindung kepada Allah dari godaan setan yang terkutuk. Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah Tuhan semesta alam... Ya Allah limpahkanlah shalawat dan keselamatan kepada junjungan kami Nabi Muhammad beserta keluarganya. Ya Allah terimalah dan sampaikanlah pahala dari apa yang kami baca dari Al-Qur\'an yang agung, tahlil, tasbih, istighfar, dan shalawat kami kepada Nabi Muhammad SAW sebagai hadiah yang sampai, rahmat yang turun, serta berkah yang merata ke hadirat kekasih kami Nabi Muhammad SAW, kepada para Nabi, Rasul, Wali, Syuhada, Shalihin, Sahabat, Tabi\'in, Ulama, Mujahidin, serta malaikat Muqarrabin. Kemudian kepada seluruh arwah penghuni kubur kaum muslimin dan muslimat, mukminin dan mukminat dari timur hingga barat, khususnya orang tua kami, kakek-nenek, guru-guru kami, serta siapa saja yang kami berkumpul di sini kerananya. Ya Allah ampunilah mereka, rahmatilah mereka, selamatkanlah mereka, dan maafkanlah mereka. Turunkanlah rahmat dan ampunan kepada ahli kubur pengucap Laa ilaaha illallaah. Ya Tuhan kami berikanlah kebaikan di dunia dan akhirat serta peliharalah kami dari siksa neraka. Dan segala puji bagi Allah Tuhan seluruh alam.',
      riwayat: 'Susunan Bacaan Tahlil ke-16 (Doa Khusus Arwah)',
    ),
    DoaItem(
      id: 117,
      urutan: 17,
      judul: '17. Penutup',
      kategori: 'Tahlil',
      teksArab: 'الْفَاتِحَة...',
      teksLatin: 'Al-Faatihah... (Membaca Surat Al-Fatihah sebagai penutup doa tahlil)',
      arti: 'Membaca surat Al-Fatihah sebagai penutup rangkaian bacaan tahlil dan doa arwah.',
      riwayat: 'Susunan Bacaan Tahlil ke-17 (Penutup)',
    ),
  ];

  static List<DoaItem> get listTahlil =>
      listDoa.where((d) => d.kategori == 'Tahlil').toList();

  static DoaItem get doaSetelahSholat =>
      listDoa.firstWhere((d) => d.id == 13);
}
