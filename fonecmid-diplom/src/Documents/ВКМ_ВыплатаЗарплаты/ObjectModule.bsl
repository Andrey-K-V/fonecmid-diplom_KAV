
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ВзаиморасчетыССотрудниками Расход
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
	Для Каждого Строка Из Выплаты Цикл
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Сотрудник = Строка.Сотрудник;
		Движение.Сумма = Строка.Сумма;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти