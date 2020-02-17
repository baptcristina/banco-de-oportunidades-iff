// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require jquery.min
//= require ahoy
//= require lang/pt_BR/bootstrap-formhelpers-countries.pt_BR
//= require bootstrap-formhelpers-languages
//= require bootstrap-formhelpers-selectbox
//= require bootstrap-formhelpers-countries
//= require bootstrap-formhelpers-states
//= require bootstrap-datepicker
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.numeric.extensions
//= require jquery.inputmask.date.extensions
//= require cocoon
//= require Chart.bundle
//= require chartkick
//= require highcharts
//= require highcharts/highcharts-more
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require jquery.maskMoney.min

//= require loader.js
//= require exporting.js
//= require offline-exporting.js
//= require export-csv.js
//= require highcharts.js
//= require_tree .

//= require bootstrap




$(document).ready(function(){
  $('.datepicker').datepicker();
  $('#telfixo').inputmask("(99) 9999-9999");
  $('#telzap').inputmask("(99) 99999-9999");  
  $('#telcom').inputmask("(99) 9999-9999");  
  $('#telcel').inputmask("(99) 99999-9999");  
  $('#cpf').inputmask("999.999.999-99");
  $('#dinheiro').maskMoney();
  $('#cep').inputmask("99.999-999")
  $('#cnpj').inputmask("99.999.999/9999-99")
  $('.dropdown-menu').find('form').click(function (e) {
        e.stopPropagation();
    });


 $('#valor').maskMoney();
});



    setTimeout("$('.error_msgs').fadeOut('xslow')", 10000)
    setTimeout("$('.success_msgs').fadeOut('xslow')", 5000)



      function readURL_foto1(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#div_foto1')
              .attr('src', e.target.result)
              .maxwidth(100)
              .maxheight(150);
          };

          Preview(document.getElementById('preview1'));
          document.getElementById('preview1').checked = true;
          reader.readAsDataURL(input.files[0]);
        }
      }

      function readURL_foto2(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#div_foto2')
              .attr('src', e.target.result)
              .maxwidth(100)
              .maxheight(150);

          };
          Preview(document.getElementById('preview2'));
          document.getElementById('preview2').checked = true;
          reader.readAsDataURL(input.files[0]);
        }
      }
      function readURL_foto3(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#div_foto3')
              .attr('src', e.target.result)
              .maxwidth(100)
              .maxheight(150);
          };
          Preview(document.getElementById('preview3'));
          document.getElementById('preview3').checked = true;
          reader.readAsDataURL(input.files[0]);
        }
      }
      function readURL_foto4(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#div_foto4')
              .attr('src', e.target.result)
              .maxwidth(100)
              .maxheight(150);
          };
          Preview(document.getElementById('preview4'));
          document.getElementById('preview4').checked = true;
          reader.readAsDataURL(input.files[0]);
        }
      }

      function readURL(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#foto')
              .attr('src', e.target.result)
              .width('100%')
              .height('100%');
          };

          reader.readAsDataURL(input.files[0]);
        }
      }
  
      function readURL2(input) {
        if (input.files && input.files[0]) {
          var reader = new FileReader();

          reader.onload = function (e) {
            $('#logo')
              .attr('src', e.target.result)
              .maxwidth(100)
              .maxheight(150);
          };

          reader.readAsDataURL(input.files[0]);
        }
      }


function printpage() {
   window.print();
}


''
function Preview(elem){
          if (elem.value == "1"){
            document.getElementById('div_foto1').style.display = "block"
            document.getElementById('div_foto2').style.display = "none"
            document.getElementById('div_foto3').style.display = "none"
            document.getElementById('div_foto4').style.display = "none"

          }
          if (elem.value == "2"){
            document.getElementById('div_foto1').style.display = "none"
            document.getElementById('div_foto2').style.display = "block"
            document.getElementById('div_foto3').style.display = "none"
            document.getElementById('div_foto4').style.display = "none"
          }
          if (elem.value == "3"){
            document.getElementById('div_foto1').style.display = "none"
            document.getElementById('div_foto2').style.display = "none"
            document.getElementById('div_foto3').style.display = "block"
            document.getElementById('div_foto4').style.display = "none"
          }
          if (elem.value == "4"){
            document.getElementById('div_foto1').style.display = "none"
            document.getElementById('div_foto2').style.display = "none"
            document.getElementById('div_foto3').style.display = "none"
            document.getElementById('div_foto4').style.display = "block"
          }
        }

function myFunction() {
    document.getElementById("em_progresso").style.visibility('hidden');
}


function atualizar() {

    if  (document.getElementById("opcao").checked == true){
      $('[id=resposta]').prop("disabled", false);
      document.getElementById("teste").style.color="#000000";
}
    if (document.getElementById("opcao").checked == false){
      $('[id=resposta]').prop("disabled", true);
      document.getElementById("teste").style.color="#BEBEBE";
}
}

function estagio() {

  if  (document.getElementById("opcao_s").checked == true){
    $('[id=empresa]').prop("disabled", false);
    document.getElementById("apaga_s_estagio").style.color="#000000";
    $('[id=nao_estagio]').prop("disabled", true);
     document.getElementById("apaga_n_estagio").style.color="#BEBEBE";
}
  if (document.getElementById("opcao_s").checked == false){
    $('[id=empresa]').prop("disabled", true);
    document.getElementById("apaga_s_estagio").style.color="#BEBEBE";
    $('[id=nao_estagio]').prop("disabled", false);
    document.getElementById("apaga_n_estagio").style.color="#000000";
    
}
}

function esta_estudando() {

    if  (document.getElementById("opcao_sim").checked == true){
      $('[id=curso]').prop("disabled", false);
      document.getElementById("cor_curso").style.color="#000000";

      $('[id=opcao_voltaria]').prop("disabled", true);
      $('[id=opcao_n_voltaria]').prop("disabled", true);
      $('[id=pq_voltaria]').prop("disabled", true);
      $('[id=pq_nao_voltaria]').prop("disabled", true);

      document.getElementById("cor_voltaria").style.color="#BEBEBE";
      document.getElementById("cor_n_voltaria").style.color="#BEBEBE";
      document.getElementById("cor_s_voltaria").style.color="#BEBEBE";

      $('[id=opcao_voltaria]').prop("checked", false);
      $('[id=opcao_n_voltaria]').prop("checked", false);
}
    if (document.getElementById("opcao_sim").checked == false){
      $('[id=curso]').prop("disabled", true);
      document.getElementById("cor_curso").style.color="#BEBEBE";

      $('[id=opcao_voltaria]').prop("disabled", false);
      $('[id=opcao_n_voltaria]').prop("disabled", false);
      $('[id=pq_voltaria]').prop("disabled", false);
      $('[id=pq_nao_voltaria]').prop("disabled", false); 

      document.getElementById("cor_voltaria").style.color="#000000";
      document.getElementById("cor_n_voltaria").style.color="#000000";
      document.getElementById("cor_s_voltaria").style.color="#000000";
}
}


function voltaria(){
    if  (document.getElementById("opcao_n_voltaria").checked == true){
      $('[id=pq_voltaria]').prop("disabled", true);
      document.getElementById("cor_s_voltaria").style.color="#BEBEBE";
      document.getElementById("pq_voltaria").value="";

      $('[id=pq_nao_voltaria]').prop("disabled", false);
      document.getElementById("cor_n_voltaria").style.color="#000000";
}
    if  (document.getElementById("opcao_n_voltaria").checked == false){
      $('[id=pq_voltaria]').prop("disabled", false);
      document.getElementById("cor_s_voltaria").style.color="#000000";

      $('[id=pq_nao_voltaria]').prop("disabled", true);
      document.getElementById("cor_n_voltaria").style.color="#BEBEBE";
      document.getElementById("pq_nao_voltaria").value="";
}
}


function trabalhando(){
    if  (document.getElementById("opcao_esta_trabalhando").checked == true){
      $('[id=opcao_trabalha_area]').prop("disabled", false);
      $('[id=opcao_n_trabalha_area]').prop("disabled", false);

      document.getElementById("cor_area").style.color="#000000";
      
      $('[id=tempo]').slice(0).prop("disabled", false);
      $('[id=vinculo]').slice(0).prop("disabled", false);
      $('[id=local]').slice(0).prop("disabled", false);
      $('[id=renda]').slice(0).prop("disabled", false);  

      document.getElementById("cor_tempo").style.color="#000000";
      document.getElementById("cor_vinculo").style.color="#000000";
      document.getElementById("cor_local").style.color="#000000";
      document.getElementById("cor_renda").style.color="#000000";   
}
    if  (document.getElementById("opcao_esta_trabalhando").checked == false){
      $('[id=opcao_trabalha_area]').prop("disabled", true);
      $('[id=opcao_n_trabalha_area]').prop("disabled", true);

      $('[id=opcao_trabalha_area]').prop("checked", false);
      $('[id=opcao_n_trabalha_area]').prop("checked", false);

      document.getElementById("cor_area").style.color="#BEBEBE";


      $('[id=tempo]').slice(0).prop("disabled", true);
      $('[id=vinculo]').slice(0).prop("disabled", true);
      $('[id=local]').slice(0).prop("disabled", true);
      $('[id=renda]').slice(0).prop("disabled", true);     

      $('[id=tempo]').slice(0).prop("checked", false);
      $('[id=vinculo]').slice(0).prop("checked", false);
      $('[id=local]').slice(0).prop("checked", false);
      $('[id=renda]').slice(0).prop("checked", false); 

      document.getElementById("cor_tempo").style.color="#BEBEBE";
      document.getElementById("cor_vinculo").style.color="#BEBEBE";
      document.getElementById("cor_local").style.color="#BEBEBE";
      document.getElementById("cor_renda").style.color="#BEBEBE"; 


      $('[id=opcao_trabalhou]').prop("disabled", false);
      $('[id=opcao_n_trabalhou]').prop("disabled", false);
      $('[id=pq_nao]').slice(0).prop("disabled", false);
      $('[id=outro1]').slice(0).prop("disabled", false);
      $('[id=texto1]').slice(0).prop("disabled", false);
      $('[id=pq_nunca]').slice(0).prop("disabled", false);
      $('[id=outro2]').slice(0).prop("disabled", false);
      $('[id=texto2]').slice(0).prop("disabled", false);

      document.getElementById("cor_trabalhou").style.color="#000000";
      document.getElementById("cor_pq_nao").style.color="#000000";
      document.getElementById("cor_pq_nunca").style.color="#000000";
}
}

function trabalha_area(){
    if  (document.getElementById("opcao_trabalha_area").checked == true){
      
      $('[id=tempo]').slice(0).prop("disabled", false);
      $('[id=vinculo]').slice(0).prop("disabled", false);
      $('[id=local]').slice(0).prop("disabled", false);
      $('[id=renda]').slice(0).prop("disabled", false);

      document.getElementById("cor_tempo").style.color="#000000";
      document.getElementById("cor_vinculo").style.color="#000000";
      document.getElementById("cor_local").style.color="#000000";
      document.getElementById("cor_renda").style.color="#000000";
      

      $('[id=opcao_trabalhou]').prop("disabled", true);
      $('[id=opcao_n_trabalhou]').prop("disabled", true);
      $('[id=pq_nao]').slice(0).prop("disabled", true);
      $('[id=outro1]').slice(0).prop("disabled", true);
      $('[id=texto1]').slice(0).prop("disabled", true);
      $('[id=pq_nunca]').slice(0).prop("disabled", true);
      $('[id=outro2]').slice(0).prop("disabled", true);
      $('[id=texto2]').slice(0).prop("disabled", true);

      $('[id=opcao_trabalhou]').prop("checked", false);
      $('[id=opcao_n_trabalhou]').prop("checked", false);
      $('[id=pq_nao]').slice(0).prop("checked", false);
      $('[id=outro1]').slice(0).prop("checked", false);
      document.getElementById("texto1").value="";
      $('[id=pq_nunca]').slice(0).prop("checked", false);
      $('[id=outro2]').slice(0).prop("checked", false);
      document.getElementById("texto2").value="";
      

      document.getElementById("cor_trabalhou").style.color="#BEBEBE";
      document.getElementById("cor_pq_nao").style.color="#BEBEBE";
      document.getElementById("cor_pq_nunca").style.color="#BEBEBE";

      
}
    if  (document.getElementById("opcao_trabalha_area").checked == false){
      $('[id=tempo]').slice(0).prop("disabled", true);
      $('[id=vinculo]').slice(0).prop("disabled", true);
      $('[id=local]').slice(0).prop("disabled", true);
      $('[id=renda]').slice(0).prop("disabled", true);

      $('[id=tempo]').slice(0).prop("checked", false);
      $('[id=vinculo]').slice(0).prop("checked", false);
      $('[id=local]').slice(0).prop("checked", false);
      $('[id=renda]').slice(0).prop("checked", false);

      document.getElementById("cor_tempo").style.color="#BEBEBE";
      document.getElementById("cor_vinculo").style.color="#BEBEBE";
      document.getElementById("cor_local").style.color="#BEBEBE";
      document.getElementById("cor_renda").style.color="#BEBEBE"; 


      $('[id=opcao_trabalhou]').prop("disabled", false);
      $('[id=opcao_n_trabalhou]').prop("disabled", false);
      $('[id=pq_nao]').slice(0).prop("disabled", false);
      $('[id=outro1]').slice(0).prop("disabled", false);
      $('[id=texto1]').slice(0).prop("disabled", false);
      $('[id=pq_nunca]').slice(0).prop("disabled", false);
      $('[id=outro2]').slice(0).prop("disabled", false);
      $('[id=texto2]').slice(0).prop("disabled", false);

      document.getElementById("cor_trabalhou").style.color="#000000";
      document.getElementById("cor_pq_nao").style.color="#000000";
      document.getElementById("cor_pq_nunca").style.color="#000000";
}
}

function trabalhou(){
    if  (document.getElementById("opcao_trabalhou").checked == true){
      $('[id=oportunidade]').slice(0).prop("disabled", false);
      $('[id=pq_nao]').slice(0).prop("disabled", false);
      $('[id=outro1]').slice(0).prop("disabled", false);
      $('[id=texto1]').slice(0).prop("disabled", false);
      $('[id=pq_nunca]').slice(0).prop("disabled", true);
      $('[id=outro2]').slice(0).prop("disabled", true);
      $('[id=texto2]').slice(0).prop("disabled", true);

      $('[id=pq_nunca]').slice(0).prop("checked", false);
      $('[id=outro2]').slice(0).prop("checked", false);
      document.getElementById("texto2").value="";
      

      document.getElementById("cor_oportunidade").style.color="#000000";
      document.getElementById("cor_pq_nao").style.color="#000000";
      document.getElementById("cor_pq_nunca").style.color="#BEBEBE";

      if (document.getElementById('pq_nao').value != "Outro"){
        document.getElementById('texto1').disabled = true;
      }else{
        document.getElementById('texto1').disabled = false;
      }
}

    if  (document.getElementById("opcao_trabalhou").checked == false){

      if  (document.getElementById("opcao_n_trabalhou").checked == true){
        $('[id=oportunidade]').slice(0).prop("disabled", true);
        $('[id=pq_nao]').slice(0).prop("disabled", true);
        $('[id=outro1]').slice(0).prop("disabled", true);
        $('[id=texto1]').slice(0).prop("disabled", true);
        $('[id=pq_nunca]').slice(0).prop("disabled", false);
        $('[id=outro2]').slice(0).prop("disabled", false);
        $('[id=texto2]').slice(0).prop("disabled", false);

        $('[id=oportunidade]').slice(0).prop("checked", false);
        $('[id=pq_nao]').slice(0).prop("checked", false);
        $('[id=outro1]').slice(0).prop("checked", false);
        document.getElementById("texto1").value="";
        

        document.getElementById("cor_oportunidade").style.color="#BEBEBE";
        document.getElementById("cor_pq_nao").style.color="#BEBEBE";
        document.getElementById("cor_pq_nunca").style.color="#000000";

      if (document.getElementById('pq_nunca').value != "Outro"){
        document.getElementById('texto2').disabled = true;
      }else{
        document.getElementById('texto2').disabled = false;
      }
      
}

      else {  
        if  (document.getElementById("opcao_trabalhou").checked == null){
          $('[id=oportunidade]').slice(0).prop("disabled", false);
}
}
}
}

function caixa1(){
      $('[id=texto1]').slice(0).prop("disabled", false);
} 

function caixa2(){
    $('[id=texto2]').slice(0).prop("disabled", false)
}



