
require 'rufus/scheduler'

# Note include file containing your rake tasks
# Else you will get - Don’t know how to build 
#task XXXXX’ error for the tasks you 
#have defined
ENV['TZ'] = 'America/Sao_Paulo'

scheduler = Rufus::Scheduler.new

scheduler.cron '1 0 * * *' do
	system("C:/Users/baptcristina.MI0407/Desktop/backup.bat")
	@oport_a_verificar =  Oportunidade.all
	@oport_a_verificar.each do |oport|
		if oport.curso == nil
			oport.delete
		end
		if oport.fim_oferta < Time.zone.now && (oport.situacao == "Vigente")
			oport.situacao = 'Expirada'
			oport.save
		end
	end
end
