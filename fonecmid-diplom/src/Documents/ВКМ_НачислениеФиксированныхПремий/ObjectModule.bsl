#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ,Режим)
	
	СформироватьДвиженияДополнительныеНачисления();
	СформироватьДвиженияУдержания();
		
	Движения.ВКМ_ДополнительныеНачисления.Записать();	
	Движения.ВКМ_Удержания.Записать();
		
	СформироватьДвижениПоРегиструВзаиморасчетыССотрудниками();
	
    //{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	//Данный фрагмент построен конструктором.
	//При повторном использовании конструктора, внесенные вручную данные будут утеряны!
	//
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияДополнительныеНачисления()

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Сотрудник КАК Сотрудник,
		|	СУММА(ВКМ_НачислениеФиксированныхПремийСписокСотрудников.СуммаПремии) КАК Результат
		|ИЗ
		|	Документ.ВКМ_НачислениеФиксированныхПремий.СписокСотрудников КАК ВКМ_НачислениеФиксированныхПремийСписокСотрудников
		|ГДЕ
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Сотрудник";
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
	Выборка= Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
	    Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ПремияСуммой;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьДвиженияУдержания()
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Сотрудник КАК Сотрудник,
		|	ВЫРАЗИТЬ(СУММА(ВКМ_НачислениеФиксированныхПремийСписокСотрудников.СуммаПремии) * 0.13 КАК ЧИСЛО(10, 2)) КАК Результат
		|ИЗ
		|	Документ.ВКМ_НачислениеФиксированныхПремий.СписокСотрудников КАК ВКМ_НачислениеФиксированныхПремийСписокСотрудников
		|ГДЕ
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Ссылка = &Ссылка
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_НачислениеФиксированныхПремийСписокСотрудников.Сотрудник";
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
	Выборка= Запрос.Выполнить().Выбрать();
		
	Пока Выборка.Следующий() Цикл
	    Движение = Движения.ВКМ_Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.ПериодРегистрации = Дата;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьДвижениПоРегиструВзаиморасчетыССотрудниками()
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_ОсновныеНачисления.Сотрудник КАК Сотрудник,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисления.Результат, 0) КАК Результат
		|ПОМЕСТИТЬ ВТ_Начисления
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
		|ГДЕ
		|	ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
		|	И ВКМ_ОсновныеНачисления.Активность
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВКМ_ДополнительныеНачисления.Сотрудник,
		|	ЕСТЬNULL(ВКМ_ДополнительныеНачисления.Результат, 0)
		|ИЗ
		|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
		|ГДЕ
		|	ВКМ_ДополнительныеНачисления.Регистратор = &Ссылка
		|	И ВКМ_ДополнительныеНачисления.Активность
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВКМ_Удержания.Сотрудник,
		|	ЕСТЬNULL(-ВКМ_Удержания.Результат, 0)
		|ИЗ
		|	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
		|ГДЕ
		|	ВКМ_Удержания.Регистратор = &Ссылка
		|	И ВКМ_Удержания.Активность
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Начисления.Сотрудник КАК Сотрудник,
		|	СУММА(ВТ_Начисления.Результат) КАК Сумма
		|ИЗ
		|	ВТ_Начисления КАК ВТ_Начисления
		|СГРУППИРОВАТЬ ПО
		|	ВТ_Начисления.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		ЗаполнитьЗначенияСвойств(Движение,Выборка);
	КонецЦикла;
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();
	
КонецПроцедуры
	
#КонецОбласти