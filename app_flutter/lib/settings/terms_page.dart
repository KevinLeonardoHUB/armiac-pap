import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.5,
          height: 1.45,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _bullets(List<String> items) {
    return Column(
      children: items.map((t) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("•  ", style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Termos de Serviço"),
        backgroundColor: cs.inversePrimary,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary.withOpacity(0.12),
                      cs.secondary.withOpacity(0.10),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: cs.primary.withOpacity(0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TERMOS DE SERVIÇO – ARMIAC (PROJETO INDIVIDUAL)",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.event, size: 18, color: cs.primary),
                        const SizedBox(width: 8),
                        const Text(
                          "Última atualização: Fevereiro de 2026",
                          style: TextStyle(
                              fontSize: 13.5, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              _paragraph(
                "Bem-vindo(a) à ARMIAC. Estes Termos de Serviço (“Termos”) regulam o acesso e utilização "
                "da aplicação móvel ARMIAC (“Aplicação” ou “Serviço”).",
              ),
              _paragraph(
                "Ao instalar, aceder ou utilizar a Aplicação, o utilizador declara que leu, compreendeu e aceita "
                "estes Termos. Caso não concorde, deverá cessar a utilização.",
              ),

              _sectionTitle("1. IDENTIFICAÇÃO DO RESPONSÁVEL"),
              _paragraph(
                "A aplicação ARMIAC é um projeto independente desenvolvido e mantido por Quévin Leonardo Aguiar "
                "Tavares, responsável pelo serviço.",
              ),
              _bullets([
                "Responsável: Quévin Leonardo Aguiar Tavares",
                "Email de contacto: kevinleonardomail@gmail.com",
                "Localização: Portugal",
              ]),

              _sectionTitle("2. DEFINIÇÕES"),
              _bullets([
                "Utilizador: qualquer pessoa que utilize a aplicação ARMIAC.",
                "Conta: registo de utilizador (quando aplicável) para acesso às funcionalidades.",
                "Conteúdo: dados, textos, imagens ou informações inseridas pelo utilizador.",
                "Serviço: aplicação ARMIAC e todas as suas funcionalidades.",
              ]),

              _sectionTitle("3. OBJETO DO SERVIÇO"),
              _paragraph("A ARMIAC disponibiliza funcionalidades digitais, podendo incluir:"),
              _bullets([
                "criação e gestão de conta;",
                "acesso a funcionalidades internas da aplicação;",
                "armazenamento de dados relacionados com o uso do serviço;",
                "atualizações e melhorias.",
              ]),
              _paragraph(
                "O Responsável pode modificar, suspender ou descontinuar funcionalidades da Aplicação a qualquer "
                "momento, por motivos técnicos, legais ou de melhoria do serviço.",
              ),

              _sectionTitle("4. CONDIÇÕES DE UTILIZAÇÃO"),
              _paragraph("Ao utilizar a Aplicação, o utilizador declara que:"),
              _bullets([
                "tem capacidade legal para aceitar estes Termos;",
                "fornecerá informações verdadeiras quando necessário;",
                "utilizará a aplicação de forma responsável e conforme a lei.",
              ]),
              _paragraph(
                "Caso o utilizador seja menor de idade, a utilização deve ser autorizada e supervisionada por um "
                "responsável legal.",
              ),

              _sectionTitle("5. CONTA E SEGURANÇA (SE APLICÁVEL)"),
              _paragraph(
                "Se a aplicação permitir criação de conta, o utilizador é responsável por manter a palavra-passe "
                "segura e confidencial, não partilhar credenciais de acesso e comunicar qualquer suspeita de acesso "
                "indevido.",
              ),
              _paragraph(
                "O Responsável não se responsabiliza por danos causados por acesso indevido resultante de negligência "
                "do utilizador.",
              ),

              _sectionTitle("6. CONDUTA DO UTILIZADOR"),
              _paragraph("O utilizador compromete-se a não utilizar a ARMIAC para:"),
              _bullets([
                "atividades ilegais ou fraudulentas;",
                "violação de direitos de terceiros;",
                "envio ou publicação de conteúdos ofensivos, difamatórios, discriminatórios ou violentos;",
                "disseminação de malware, vírus ou tentativas de ataque informático;",
                "tentativa de acesso não autorizado a sistemas ou dados.",
              ]),
              _paragraph("O uso indevido pode resultar na suspensão ou bloqueio do acesso ao Serviço."),

              _sectionTitle("7. PROPRIEDADE INTELECTUAL"),
              _paragraph(
                "O nome ARMIAC, logotipo, design, código-fonte, estrutura, funcionalidades e identidade visual são "
                "propriedade do Responsável pelo Serviço, estando protegidos por legislação de direitos de autor e "
                "propriedade intelectual.",
              ),
              _paragraph(
                "É proibida a reprodução, modificação, distribuição ou exploração comercial da aplicação ou do seu "
                "conteúdo sem autorização prévia por escrito.",
              ),

              _sectionTitle("8. CONTEÚDO INSERIDO PELO UTILIZADOR"),
              _paragraph(
                "O utilizador é o único responsável pelo conteúdo que inserir na aplicação, garantindo que possui "
                "direitos sobre os dados ou autorização para os utilizar, não viola direitos de terceiros e não publica "
                "conteúdos ilegais.",
              ),
              _paragraph(
                "O Responsável reserva-se o direito de remover conteúdos que violem estes Termos ou a legislação aplicável.",
              ),

              _sectionTitle("9. PRIVACIDADE E PROTEÇÃO DE DADOS (RGPD)"),
              _paragraph(
                "A ARMIAC respeita a privacidade do utilizador e compromete-se a tratar os dados pessoais com segurança.",
              ),
              _paragraph(
                "O tratamento de dados pessoais é realizado conforme o Regulamento (UE) 2016/679 (RGPD) e a Lei n.º 58/2019, "
                "de 8 de agosto (Portugal).",
              ),
              _paragraph(
                "Os dados recolhidos podem incluir informações necessárias para funcionamento da aplicação, melhoria do serviço "
                "e suporte ao utilizador.",
              ),

              _sectionTitle("10. DISPONIBILIDADE E MANUTENÇÃO"),
              _paragraph(
                "O Responsável procura manter a aplicação disponível, mas não garante funcionamento contínuo ou livre de falhas.",
              ),
              _paragraph("A aplicação pode ficar temporariamente indisponível devido a:"),
              _bullets([
                "manutenção técnica;",
                "atualizações;",
                "falhas de internet ou servidores;",
                "motivos de segurança;",
                "eventos de força maior.",
              ]),

              _sectionTitle("11. LIMITAÇÃO DE RESPONSABILIDADE"),
              _paragraph("Na extensão permitida pela legislação aplicável, o Responsável não será responsável por:"),
              _bullets([
                "perdas indiretas ou lucros cessantes;",
                "danos decorrentes de falhas técnicas, indisponibilidade ou interrupções;",
                "problemas causados por dispositivos do utilizador;",
                "uso indevido do Serviço por terceiros;",
                "erros resultantes de informações inseridas pelo utilizador.",
              ]),
              _paragraph("O utilizador reconhece que utiliza a aplicação por sua conta e risco."),

              _sectionTitle("12. SERVIÇOS PAGOS (SE APLICÁVEL)"),
              _paragraph(
                "Caso a ARMIAC venha a disponibilizar funcionalidades pagas, os preços e condições serão apresentados "
                "antes da contratação.",
              ),
              _paragraph(
                "O utilizador concorda que os valores podem ser atualizados, poderão existir planos recorrentes e reembolsos "
                "seguirão as regras da plataforma (Google Play / App Store) e legislação aplicável.",
              ),

              _sectionTitle("13. CANCELAMENTO E ELIMINAÇÃO DE CONTA"),
              _paragraph("O utilizador pode deixar de utilizar a aplicação a qualquer momento."),
              _paragraph(
                "Quando aplicável, o utilizador poderá solicitar a eliminação de conta e dados através do contacto oficial "
                "disponibilizado.",
              ),
              _paragraph(
                "O Responsável pode suspender ou eliminar contas em caso de violação destes Termos ou exigência legal.",
              ),

              _sectionTitle("14. ALTERAÇÕES DOS TERMOS"),
              _paragraph(
                "O Responsável pode atualizar estes Termos periodicamente. Caso existam alterações relevantes, o utilizador "
                "poderá ser informado através da aplicação.",
              ),
              _paragraph("O uso contínuo após atualização significa aceitação dos novos Termos."),

              _sectionTitle("15. LEI APLICÁVEL E FORO"),
              _paragraph("Estes Termos são regidos pela legislação portuguesa e legislação aplicável da União Europeia."),
              _paragraph(
                "Para resolução de litígios, será competente o foro da comarca do domicílio do Responsável, salvo norma legal "
                "imperativa em contrário.",
              ),

              _sectionTitle("16. CONTACTO"),
              _paragraph("Para dúvidas, suporte ou solicitações relacionadas com estes Termos, o utilizador poderá contactar:"),
              _bullets([
                "Email: kevinleonardomail@gmail.com",
              ]),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DECLARAÇÃO FINAL",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Ao utilizar a aplicação ARMIAC, o utilizador declara que leu e concorda com os presentes Termos de Serviço.",
                      style: TextStyle(fontSize: 14.5, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
