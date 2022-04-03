## DBS Zadanie 4 dokumentácia 

**Autori:** Boris Novák, Peter Debnár 
**Predmet:** Databázové systémy 
**Školský rok:** 2021/2022 
**Cvičiaci:** Ing. Ján Lučanský 

### Popis k bodom zadania 

#### Registrácia hráča (bod 1) 

Všetci registrovaní hráči, ktorí môžu hrať hru sa nachádzajú v tabulke users. Od užívateľa vyžadujeme meno užívateľa, jeho email a heslo k účtu. Meno užívateľa, tak ako aj email musia byť jedinečné. Registrovaný užívateľ sa bude musieť verifikovať cez zadaný email, či tak učinil si budeme zapisovať v atribúte verified. Pri každom užívateľovi si taktiež zapisujeme čas, kedy sa naposledy napojil do hry a ako dlho hral hru v hodinách. 

#### Priateľstvo (bod 2) 

Priateľstvo riešime cez tabuľku friends, kde si ukladáme priateľstvo medzi užívateľom user_id_1 a user_id_2. Hráči sa medzi sebou spriatelia, pokiaľ jeden z nich tomu druhému pošle pozvánku na priateľstvo. Tá sa ukladá do tabuľky request a ako atribúty má user_id - hráč, pre ktorého je pozvánka určená, request_from - hráč, ktorý pozvánku poslal a nakoniec type_of_request - typ pozvánky. Nakoľko v tejto tabuľke riešime aj pozvánky do tímu, máme dva typy pozvánok. V prípade pozvánky na priateľstvo sa do tohto atribútu zapíše písmeno F (friend). Pozvánka bude v tabuľke uložená, kým nebude buď odmietnutá, alebo prijatá. Následne sa zmaže. Ak sa prijme, priateľstvo sa zapíše do tabuľky friends. Hráč nemôže poslať pozvánku sám sebe a taktiež sa nemôže sám so sebou spriateliť. 

#### Team (bod 3) 

Keďźe sme chat riešili pomocou chat_roomov, tak sme nepridávali tabuľku team, prišlo nám to zbytočné, keďže si vieme pomocou participants nájsť pouźivateľa a vybrať chat_room, ktorá nie je private a tak zistíme, kto sa v teame nachádza. Pri odídení hráća z teamu sa odstráni z participants a odpojí ho aj z chat_roomu 

#### Chat + Team (bod 4) 

Chat sme riešili pomocou chat_rooms. Každá chat_room má svoje meno a hodnotu is_private na základe, ktorej zistím, či je room private alebo team. Následne má chat_room minimálne 2 participantov. V tabuľke message uchovávame všetky správy pre každú chat_room od akého použivateľa bola poslaná a čo sa v správe nachádzalo. 

#### Postavy hráča (bod 5) 

Hráč si môže v rámci hry vytvoriť viacero herných postáv, ktoré sa ukladajú do tabuľky character. Každá postava má svoje vlastné meno, ktoré sa nemôže zhodovať so žiadnym menom inej postavy. Pre každú postavu si hráč zvolí jej rolu, túto informáciu ukladáme ako role_id (referencia na tabulku role). Každá postava môže mať len jednu rolu. Ako ďalšie informácie zapisujeme XP postavy, jej level (level_id s refrenciou na tabulku level) a koľko peňazí vlastní postava (money). Následne si zapisujeme staty každej postavy, a to útok, život, obranu, rýchlosť, inteligenciu, obratnosť a šťastie. 

#### Príšery (bod 6) 

Na mape sa okrem iného nachádzajú rôzne príšery. Zoznam všetkých príšer je v tabuľke enemy. Tá obsahuje atribúty name - meno príšery, level - jej level a status - či je aktuálne príšera mŕtva alebo žije. Príšery sa ukazujú len postavám, ktoré majú level v rámci rozsahu levelu príšery, ktorý určuje atribút level_radius, inými slovami ak je lvl príšery 20 a level_radius je 5, zobrazuje sa príšera len postavám, ktoré majú level v rozsahu 15 až 25. Za zabitie príšery dostane postava xp a peniaze (money). Každá príšera má rovnako ako postava staty, konkrétne útok (attack), život (health) a obrana (defense). Po zabití príšery je nejaká šanca, že z nej dostane postava predmet. Na to slúži atribút drop_rate. Na poslednom podlaží v rámci mapy je boss, identifikujeme ho cez atribút is_boss. Posledný a najsilneší boss hre, ktorého má hráč za úlohu zabiť sa identifikuje pomocou atribútu is_final_boss. Niektoré príšery sa postavám odomykajú až po tom, čo splnia nejakú úlohu. Toto ošetruje atribút quest_id, ktorý obsahuje id úlohy, ktorú je potrebné splniť. Pre niektoré príšery netreba splniť žiadnu úlohu, vtedy obsahuje tento atribút NULL. Iné príšery sa odomknú po zabití inej príšery vďaka tabulke required_enemy, ktorá obsahuje atribúty enemy_id - id príšery a required_id - id príšery, ktorú pred tým treba zabiť. Každá príšera má jednu alebo viac schopností. Túto informáciu máme uloženú v tabuľke enemy_ability s atribútmi enemy_id - id príšery a ability_id - id schopnosti. O tom, kde sa príšera nachádza nám hovorí tabuľka enemy_location. map_id je id mapy, enemy_id je id príšery, floor je poschodie na mape a x, y sú súradnice. 

#### Úlohy (bod 7) 

Postava má možnosť plniť úlohy. Za úspešné splnenie úloh môže postava získať XP, peniaze a prípadne aj predmet. Všetky úlohy sú zaznamenané v tabuľke quest. Tabuľka obsahuje atribúty name - meno úlohy, required_level - minimálny level, ktorý musí mať postava na to, aby mohla plniť quest. Meno úlohy musí byť jedinečné. Následne obsahuje všetky odmeny za splnenie úlohy, čiže xp - body skúsenosti, money - počet peňazí, item_id - predmet. XP a peniaze, ktoré získa hráč za splnenie úlohy nemôžu byť negatívne čísla. Posledné atribúty sú place_id - miesto, kde sa quest odohráva a description - popis úlohy. Pre splnenie jednotlivých úloh bude musieť hráč zabiť niekoľko príšer. Tieto informácie si zapisujeme v tabuľke quest_enemy s atribútami quest_id - úloha, ku ktorej sa informácia vzťahuje, enemy_id - príšera, ktorú treba zabiť a amount - počet týchto príšer. Keď postava spustí úlohu, tá sa zapíše aj do tabuľky character_quest s atribútmi character_id - postava, ktorá začala s úlohou a quest_id - o ktorú úlohu ide. 

#### Levely a Schopnosti (bod 8) 

Postava získava zabíjaním príšer a plnením úloh xp. Po dosiahnutí istého množstva xp sa mu navýši level a počet xp sa zresetuje. Tabuľka level obsahuje všetky levely, každý jeden zapísaný v atribúte level_label. Ku každému levelu je taktiež priradený atribút xp - počet xp (bodov skúsenosti), ktorý musí postava dosiahnuť, aby sa dostala na daný level (level_label). Zvyšovaním levelu si postava môže odomknuť rôzne schopnosti. Zoznam schopností postáv, ako aj schopnosti príšer sa nachádza v tabuľke ability. Pre každú schopnosť si značíme name - meno schopnosti, level - potrebný level na otvorenie schopnosti a description - popisok ku schopnosti. Na otvorenie niektorých schopností je nutné okrem dosiahnutia istého levelu taktiež odomknúť inú predchádzajúcu schopnosť. Tieto informácie si ukladáme v tabuľke ability_requirement s atribútami ability_id - schopnosť, ktorá požaduje pred odomknutím vlastniť inú schopnosť a requirement_id - schopnosť, ktorú treba vlastniť. Schopnosti taktiež odomykajú rôzne bonusy, ktoré sú v tabuľke bonus. Môže ísť o zvýšenie útoku (attack), života (health), obrany (defense), rýchlosti (movement_speed), inteligencie (intelligence), obratnosti (dexterity) alebo šťastia, prípadne viacerých naraz. Každý bonus má svoje meno (name). Zároveň, každá schopnosť môže dávať viac bonusov naraz, preto používame tabuľku ability_bonus, kde schopnosti (ability_id) priradíme jeden z bonusov (bonus_id). Všetky schopnosti, ktoré má postava odomknuté nájdeme v tabuľke character_ability, kde character_id je id postavy a ability_id je id schopnosti. 

#### Exp body za LVL (bod 9) 

V tabuľke role sa nachádza názov roly a taktiež parametre attack, health a defense, ktoré značia koľko dostane daná rola k daným atribútom. 

#### Mapa (bod 10) 

V tabuľke map sa nachádza floor, ktorý určuje poschodie mapy, x a y, ktoré určujú veľkosť mapy. Na mapu sa viažu tabuľky character_location, enemy_location, item_location a place_location. Tieto tabuľky slúžia ako spájacie tabuĺky s tabuľkami character, enemy a item, kde sa taktiež nachádzajú informácie o poschodí, na ktorom sa nachádzajú a súradnice x a y presné pozície na mape. Place ako ostatné tabuľky reprezentuje, kde sa nachádza dané miesto na mape, len na rozdiel od, ostatných tabuliek dané miesto sa môźe na mape nachadzať len jedenkrát. 

#### Itemy (bod 11) 

V tabuľke itemy máme názov predmetu, jeho level a opis predmetu. Predmet je napojeny na tabuľku quest vo vzťahu many to one, kde za úlohu môžeme získať len jeden item, ale daný item je možné získať v rôznych úlohách. Taktiež sa item viaźe na inventár cez spájaciu tabuľku inventory_item, kvôli tomu že inventár má viacero predmetov a tie predmety sa môžu nachádzať v rôznych inventároch a taktiež sa tu nachádza informácia otom či sa daný item pouźíva. Inventár je napájaný na character vo vzťahu 1 to 1, pretože inventár je unikátny pre každý charakter. Následne je napojený na tabuĺku bonus pomocou spájacej tabuľky item_bonus, kde predmet môže mať viacero bonusov a tieto bonusy môžu patriť viacerým predmetom. Následne je predmet viazaný na tabuľku item_location, pretože item môže mať svoju polohu ak sa nachádza niekde na zemi, po zabití príšery. 

#### Boj a auditovanie (bod 12) 

Riešené pomocou napojenia tabuliek character a enemy na tabuľku combat, ktorá obsahuje character_id a enemy_id. Každá akcia v danom combate sa zapisuje do combat logu v podobe character_id, enemy_id, place_id - miesto kde sa daná akcia stala, ability_id - aká abilita bola vykonaná, current_time - kedy sa tak stalo a xp a money či za danú akciu character niečo získal.