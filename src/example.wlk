class Linea{
	var nroTelefono
	const packs=[]
	const consumos=[]
	
	method costoPromedioEntre(fechaInicial,fechaFinal)=self.costoConsumidosEntre(fechaInicial,fechaFinal)/self.cantidadConsumosEntre(fechaInicial,fechaFinal)
	
	method costoConsumidosEntre(fechaInicial,fechaFinal)=self.consumosEntre(fechaInicial,fechaFinal).sum({consumo=>consumo.costo()})
	
	method consumosEntre(fechaInicial,fechaFinal)=consumos.filter({consumo=>consumo.consumidoEntre(fechaInicial,fechaFinal)})
	
	method cantidadConsumosEntre(fechaInicial,fechaFinal)=self.consumosEntre(fechaInicial,fechaFinal).size()
	
	method constoTotalUltimos30dias(fechaActual)=self.costoConsumidosEntre(fechaActual,fechaActual-30)
	
}

class Consumo{
	const property fechaRealizado = new Date()
	method consumidoEntre(fechaInicial,fechaFinal)=fechaRealizado.between(fechaInicial,fechaFinal)
	method costo()
	
}

class ConsumoInternet inherits Consumo{
	var property cantidadMb
	
	override method costo()=cantidadMb*pdepFoni.precioMb()
}

class ConsumoLlamada inherits Consumo{
	var property cantidadSegundos
	
	override method costo()=pdepFoni.costoSegundo()*cantidadSegundos+pdepFoni.costoFijo()
}

object pdepFoni{
	var property precioMb=0.1
	var property costoFijo=1
	var property costoSegundo=0.05
}



class pack{
	var vigencia=ilimitado
	method satisfase(consumo)= not vigencia.vencido() and self.cubre(consumo)
	
	method cubre(consumo)
}



class packConsumible inherits pack{
	const property cantidad
	const consumos = []

	method consumir(consumo) {
		consumos.add(consumo)
	}
	method remanente() = cantidad - self.cantidadConsumida()
}

class Credito inherits PackConsumible {

	override method cubre(consumo) = consumo.costo() <= self.remanente()

}

class MBsLibres inherits PackConsumible {

	override method cubre(consumo) = consumo.cubiertoPorInternet(self)

	method puedeGastarMB(cantidad) = cantidad <= self.remanente()

}

class MBsLibresPlus inherits MBsLibres {

	override method puedeGastarMB(cantidad) = super(cantidad) || cantidad < 0.1

}

class PackIlimitado inherits Pack {

	method consumir(consumo) {
	}

	override method acabado() = false

	method puedeGastarMB(cantidad) = true

	method puedeGastarMinutos(cantidad) = true

}

class LlamadasGratis inherits PackIlimitado {

	override method cubre(consumo) = consumo.cubiertoPorLlamadas(self)

}

class InternetLibreLosFindes inherits PackIlimitado {

	override method cubre(consumo) = consumo.cubiertoPorInternet(self) && consumo.fechaRealizado().internalDayOfWeek() > 5

}
object ilimitado{
	method vencido() = false
}

class Vencimiento {

	const fecha

	method vencido() = fecha < new Date()

}