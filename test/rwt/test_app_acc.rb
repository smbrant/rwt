# 
# An example app using ExtLib
# 
 
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'
include Rwt

class TestAppAcc < Test::Unit::TestCase
  def test_basic
#
# old syntax:
#
#   b=App.new do |app|
#      app << Component.new({:xtype=>'tbtext',:text=>'<b>Fianseg:</b>'})
#      app << Dict.new({
#          :text=>'Seguros',
#          :menu=>Ext::Menu::Menu.new({
#              :id=>'menSeguros',
#              :items=>List.new do |l|
#                  l << Dict.new({:text=>'Fiança Locatícia'})
#                  l << Dict.new({:text=>'Incêndio'})
#              end                  
#            })
#        })

#
# New syntax
#
    b=SimpleApp.new do |app|
      app << Ext::Component.new({:xtype=>'tbtext',:text=>'<b>Fianseg:</b>'})
      app << {
          :text=>'Seguros',
          :menu=>Ext::Menu::Menu.new({
              :items=> [
                  {:text=>'Fiança Locatícia'},
                  {:text=>'Incêndio'}
              ]                  
            })
        }
      app << {
          :text=>'Cadastros',
          :menu=>Ext::Menu::Menu.new({
              :items=>[
                 {:text=> 'Atividade', :handler=> app.jsFromUrl('/atividade/index.js')},
                 {:text=> 'Cidade', :handler=> app.jsFromUrl('/cidade/index.js')},
                 {:text=> 'Estado Civil', :handler=> app.jsFromUrl('/estado_civil/index.js')},
                 {:text=> 'Estipulante', :handler=> app.jsFromUrl('/posts.js')},
                 {:text=> 'Índices'},
                 {:text=> 'Profissão'},
                 {:text=> 'Proponente Físico'},
                 {:text=> 'Proponente Jurídico'},
                 {:text=> 'Regime Casamento'},
                 {:text=> 'Usuário'},
                 {:text=> 'Unidade Federativa'},
                 '-',
                 {:text=> 'Tabelas Restritas'}
                
                ]
            })
        }
      app << {
         :text=> 'Relatórios',
         :menu=> Ext::Menu::Menu.new({
             :items=> [
                 {:text=> 'Desempenho das Imobiliárias'},
                 {:text=> 'Desempenho dos Corretores'}
              ]
          })
        }
    end
    
    assert(b.render!='', 'Basic')
  end
end

