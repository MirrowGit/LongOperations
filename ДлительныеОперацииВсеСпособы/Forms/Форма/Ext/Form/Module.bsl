﻿
&НаКлиенте
Процедура ЗапуститьВыполнение(Команда)
		//ореноьтено	
	ИДЗадания =  "";
	Индикатор = 0;
	СтрокаСостояния = "";
	
	ПараметрыЗапуска = ПодготовитьДанныеДляДлительнойОперации();
	//ПараметрыЗапуска = Новый Структура;
	СтруктураФоновогоЗадания = ВыполнитьФоновоеЗаданиеНаСервере(ПараметрыЗапуска, УникальныйИдентификатор);
	ИДЗадания = СтруктураФоновогоЗадания.ИдентификаторЗадания;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	// указываем необходимость вывода окна с индикацией
	//если используем индикатор на форме, то вывод окна можно установить как Ложь
	//ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	// указываем необходимость вывода прогресса состояния
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	// указываем интервал обновления состояния в секундах, если не указать, 
	// то интервал будет увеличиваться при каждой итерации в 1.4 раза.
	ПараметрыОжидания.Интервал = 1;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		СтруктураФоновогоЗадания,
		Новый ОписаниеОповещения("ОбработатьДанные", ЭтотОбъект),
		ПараметрыОжидания);
	
	//++Индикатор
	ПодключитьОбработчикОжидания("ОбработчикОжиданияИндикатор", 1);
 	//--Индикатор
	
КонецПроцедуры

&НаКлиенте
Функция ПодготовитьДанныеДляДлительнойОперации()
	
	Рез = Новый Структура;
	Рез.Вставить("КоличествоИтераций", КоличествоИтераций);
	
	//Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
	//	// обработка подключена к подсистеме дополнительных отчетов/обработок
	//	Рез.Вставить("ИспользуемоеИмяФайла", "ВнешняяОбработка.ДлительныеОперацииВоВнешнейОбработке");
	//	Рез.Вставить("ДополнительнаяОбработкаСсылка", ОбъектСсылка);
	//Иначе
	//	// не подключена
	//	Рез.Вставить("ИспользуемоеИмяФайла", ИмяФайлаОбработки()); // имя файла этой внешней обработки
	//	Рез.Вставить("ДополнительнаяОбработкаСсылка", ПредопределенноеЗначение("Справочник.ДополнительныеОтчетыИОбработки.ПустаяСсылка"));
	//КонецЕсли;
	
	Возврат Рез;
	
КонецФункции

&НаСервере
Функция ИмяФайлаОбработки()

	Возврат РеквизитФормыВЗначение("Объект").ИспользуемоеИмяФайла;
	
КонецФункции

&НаСервере
Функция ЭтоВнешняяОбработка()
	
	ЧастиИмени = СтрРазделить(РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя(), ".");
	Возврат (ВРег(ЧастиИмени[0]) = "ВНЕШНЯЯОБРАБОТКА")
	
КонецФункции

&НаСервере
Функция ВыполнитьФоновоеЗаданиеНаСервере(ПараметрыЗапуска, УникальныйИдентификатор)

	НаименованиеЗадания = НСтр("ru = 'Запуск длительной операции'");
	
	ДополнительнаяОбработкаСсылка = Справочники.ДополнительныеОтчетыИОбработки.НайтиПоНаименованию("Пример длит. операций во внешней обработке");
	ВыполняемыйМетод = "ДлительныеОперации.ВыполнитьПроцедуруМодуляОбъектаОбработки";
	ЭтоВнешняяОбработка = ЭтоВнешняяОбработка();
	Если НЕ ЭтоВнешняяОбработка Тогда
		ИмяОбработки = РеквизитФормыВЗначение("Объект").Метаданные().Имя;
	Иначе
		ИмяОбработки = ИмяФайлаОбработки();
		Если СтрНайти(ИмяОбработки, "tempstorage") = 0 Тогда
			ДополнительнаяОбработкаСсылка = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Структура; 
	ПараметрыЗадания.Вставить("БезопасныйРежим", Ложь);
	ПараметрыЗадания.Вставить("ИмяОбработки", ИмяОбработки);
	ПараметрыЗадания.Вставить("ИмяМетода", "ДлительнаяОперация");
	ПараметрыЗадания.Вставить("ПараметрыВыполнения", ПараметрыЗапуска);
	ПараметрыЗадания.Вставить("ЭтоВнешняяОбработка", ЭтоВнешняяОбработка);
	ПараметрыЗадания.Вставить("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.Вставить("ИдентификаторФормы", УникальныйИдентификатор); 
	
	СтруктураФоновогоЗадания = ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыЗадания, ПараметрыВыполнения);
	
	Возврат СтруктураФоновогоЗадания;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьДанные(Результат, ДополнительныеПараметры) Экспорт

	//++Индикатор
	ОтключитьОбработчикОжидания("ОбработчикОжиданияИндикатор");
 	//--Индикатор
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		//++Индикатор
		СтрокаСостояния = "Задание завершено с ошибками.";
	 	//--Индикатор
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		// обрабатываем результат
		Данные = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ВозвратноеЗначение = Данные.Количество();
		//++Индикатор
		Индикатор = 100;
		СтрокаСостояния = "Задание завершено.";
	 	//--Индикатор
	КонецЕсли;

КонецПроцедуры

#Область Индикатор
&НаКлиенте 
Процедура ОбработчикОжиданияИндикатор() Экспорт 
	
	Прогресс = ПрочитатьПрогресс(ИДЗадания);
	
	Если НЕ ТипЗнч(Прогресс) = Тип("Структура") Тогда
		СтрокаСостояния = "";
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Прогресс) = Тип("Структура") 
		И Прогресс.Свойство("ЗавершеноАварийно") Тогда
		ОтключитьОбработчикОжидания("ОбработчикОжиданияИндикатор");
		Возврат;
	КонецЕсли;
	
	Если Прогресс.Свойство("ЗаданиеВыполнено") И Прогресс.ЗаданиеВыполнено Тогда
		Индикатор = 100;
		СтрокаСостояния = "Задание завершено.";
	Иначе
		Если Прогресс.Свойство("Процент") Тогда
			Индикатор = Прогресс.Процент;
		КонецЕсли;
		Если Прогресс.Свойство("Текст") Тогда
			СтрокаСостояния = Прогресс.Текст;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
	
Функция ПрочитатьПрогресс(Знач ИдентификаторФоновогоЗадания) Экспорт
	
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторФоновогоЗадания);
	Если Задание = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
//		ОтключитьОбработчикОжидания("ОбработчикОжиданияИндикатор");
		Возврат Неопределено;
	КонецЕсли;
	
	ПрогрессЗадания = ДлительныеОперации.ПрочитатьПрогресс(ИдентификаторФоновогоЗадания);
	
	// Добавляем флаг "ЗаданиеВыполнено", чтобы различать случаи: когда отсутствуют сообщения и когда завершено задание.
	Если ПрогрессЗадания = Неопределено
	 Или ТипЗнч(ПрогрессЗадания) <> Тип("Структура") Тогда // или нет задания, или нет сообщений
		ПрогрессЗадания = Новый Структура;
	КонецЕсли;
	ПрогрессЗадания.Вставить("ЗаданиеВыполнено", ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания));
	
	Возврат ПрогрессЗадания;
	
КонецФункции

#КонецОбласти 
