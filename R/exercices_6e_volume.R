# Experimental high-volume generators for 6e.
# Human-facing text lives in inst/exercices/textes_*.csv.

.qcm_6e_nombre = function(txt, bonne, faux) {
  faux = faux[is.finite(faux) & !is.na(faux) & faux != bonne]
  faux = unique(faux)
  candidat = bonne + c(-3, -2, -1, 1, 2, 3, 5, 10)
  faux = unique(c(faux, candidat[candidat != bonne]))
  faux = faux[seq_len(3L)]
  valeurs = c(bonne, faux)
  ordre = sample(seq_len(4L))
  list(
    intention = txt[["intention"]],
    forme_question = "calcul_direct",
    notion = txt[["notion"]],
    definition = txt[["definition"]],
    rappel = txt[["rappel"]],
    propositions = as.character(valeurs[ordre]),
    correcte = match(1L, ordre),
    feedback = c(txt[["correction"]], rep(txt[["feedback_faux"]], 3L))[ordre]
  )
}

.generer_6e_volume = function(modele_id, famille, niveau_id = "6E",
                               capacite_id = NA_character_, difficulte = 1,
                               seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  txt = .textes_exercice(famille, modele_id)

  z = switch(modele_id,
    NUM_COMPARE_001 = {
      a = sample(100000:999999, 1L); b = sample(setdiff((a-80):(a+80), a), 1L)
      bonne = if (a > b) 1 else 2
      list(args = list(a, b), bonne = bonne, faux = c(3, 4, 5), p = list(a=a,b=b))
    },
    NUM_DECOMP_001 = {
      m = sample(2:9,1L); c = sample(1:9,1L); d = sample(1:9,1L); u = sample(1:9,1L)
      n = m*1000+c*100+d*10+u
      list(args=list(n), bonne=m*1000, faux=c(c*100,d*10,u), p=list(n=n,m=m,c=c,d=d,u=u))
    },
    DEC_MULT_001 = {
      a = sample(12:99,1L)/10; b = sample(2:9,1L); bonne = a*b
      list(args=list(a,b), bonne=bonne, faux=c(a+b, bonne*10, bonne/10), p=list(a=a,b=b))
    },
    OP_CHOICE_001 = {
      a=sample(20:80,1L); b=sample(2:15,1L); bonne=a-b
      list(args=list(a,b), bonne=bonne, faux=c(a+b,a*b,round(a/b,2)), p=list(a=a,b=b))
    },
    INCONNUE_001 = {
      x=sample(2:30,1L); a=sample(2:20,1L); total=x+a
      list(args=list(a,total), bonne=x, faux=c(total+a,total,a), p=list(a=a,total=total,x=x))
    },
    REG_SUITE_001 = {
      depart=sample(2:20,1L); pas=sample(2:9,1L); suite=depart+0:3*pas; bonne=depart+4*pas
      list(args=as.list(suite), bonne=bonne, faux=c(bonne-pas+1,bonne+pas,bonne*2), p=list(depart=depart,pas=pas))
    },
    PER_RECT_001 = {
      l=sample(3:20,1L); L=sample((l+1):30,1L); bonne=2*(L+l)
      list(args=list(L,l), bonne=bonne, faux=c(L+l,L*l,2*L+l), p=list(L=L,l=l))
    },
    AIRE_RECT_001 = {
      l=sample(2:15,1L); L=sample(3:20,1L); bonne=L*l
      list(args=list(L,l), bonne=bonne, faux=c(2*(L+l),L+l,L*l+L), p=list(L=L,l=l))
    },
    AIRE_CONV_001 = {
      m2=sample(2:15,1L); bonne=m2*10000
      list(args=list(m2), bonne=bonne, faux=c(m2*100,m2*1000,m2*100000), p=list(m2=m2))
    },
    VOL_PAVE_001 = {
      a=sample(2:8,1L); b=sample(2:8,1L); c=sample(2:8,1L); bonne=a*b*c
      list(args=list(a,b,c), bonne=bonne, faux=c(a*b+c,a+b+c,2*(a*b+a*c+b*c)), p=list(a=a,b=b,c=c))
    },
    DUREE_CONV_001 = {
      h=sample(1:5,1L); m=sample(c(10,15,20,25,30,35,40,45,50),1L); bonne=60*h+m
      list(args=list(h,m), bonne=bonne, faux=c(100*h+m,60*h,bonne+60), p=list(h=h,m=m))
    },
    TRI_ANGLE_001 = {
      a=sample(25:80,1L); b=sample(25:(150-a),1L); bonne=180-a-b
      list(args=list(a,b), bonne=bonne, faux=c(360-a-b,180-a+b,a+b), p=list(a=a,b=b))
    },
    MED_EQUIDIST_001 = {
      d=sample(2:20,1L); bonne=d
      list(args=list(d), bonne=bonne, faux=c(d+1,d+2,max(0,d-1)), p=list(d=d))
    },
    CERCLE_DIAM_001 = {
      r=sample(2:20,1L); bonne=2*r
      list(args=list(r), bonne=bonne, faux=c(r,r*3,r+2), p=list(r=r))
    },
    SYM_AXE_001 = {
      x=sample(1:9,1L); bonne=-x
      list(args=list(x), bonne=bonne, faux=c(x,0,-x-1), p=list(x=x))
    },
    DATA_FILTER_001 = {
      v=sample(1:9,6L,replace=TRUE); seuil=sample(4:7,1L); bonne=sum(v>=seuil)
      faux=unique(c(sum(v>seuil),sum(v<=seuil),length(v)-bonne,bonne+1L,bonne-1L)); faux=faux[faux!=bonne & faux>=0][1:3]
      if (length(faux)<3L) faux=c((bonne+1):(bonne+3))
      list(args=list(paste(v,collapse=", "),seuil), bonne=bonne, faux=faux, p=list(v=v,seuil=seuil))
    },
    PROBA_SIMPLE_001 = {
      total=sample(4:10,1L); fav=sample(1:(total-1),1L); bonne=round(fav/total,3)
      list(args=list(fav,total), bonne=bonne, faux=c(round((total-fav)/total,3),round(fav/(total+1),3),round(1/total,3)), p=list(fav=fav,total=total))
    },
    FREQ_SIMPLE_001 = {
      total=sample(c(20,40,50,100),1L); fav=sample(2:(total-2),1L); bonne=round(fav/total,3)
      list(args=list(fav,total), bonne=bonne, faux=c(round((total-fav)/total,3),round(fav/100,3),round(fav/(total+10),3)), p=list(fav=fav,total=total))
    },
    ECHELLE_001 = {
      e=sample(c(100,200,500,1000),1L); plan=sample(2:12,1L); bonne=plan*e/100
      list(args=list(e,plan), bonne=bonne, faux=c(plan*e,plan/e,plan*100/e), p=list(e=e,plan=plan))
    },
    BOUCLE_001 = {
      depart=sample(1:10,1L); pas=sample(2:6,1L); n=sample(3:6,1L); bonne=depart+n*pas
      list(args=list(depart,pas,n), bonne=bonne, faux=c(depart+(n-1)*pas,n*pas,depart+n+pas), p=list(depart=depart,pas=pas,n=n))
    }
  )

  enonce = do.call(sprintf, c(list(txt[["enonce"]]), z$args))
  correction = do.call(sprintf, c(list(txt[["correction"]]), z$args, list(z$bonne)))
  qcm_txt = txt
  qcm_txt[["correction"]] = correction
  qcm = .qcm_6e_nombre(qcm_txt, z$bonne, z$faux)
  creer_exercice(modele_id, niveau_id, capacite_id, difficulte, enonce,
                 as.character(z$bonne), correction, z$p, seed, qcm=qcm)
}

.fabrique_generateur_6e = function(modele_id, famille) {
  force(modele_id); force(famille)
  function(niveau_id="6E", capacite_id=NA_character_, difficulte=1, seed=NULL) {
    .generer_6e_volume(modele_id, famille, niveau_id, capacite_id, difficulte, seed)
  }
}

generer_num_compare = .fabrique_generateur_6e("NUM_COMPARE_001", "nombres_6e")
generer_num_decomp = .fabrique_generateur_6e("NUM_DECOMP_001", "nombres_6e")
generer_dec_mult = .fabrique_generateur_6e("DEC_MULT_001", "nombres_6e")
generer_op_choice = .fabrique_generateur_6e("OP_CHOICE_001", "nombres_6e")
generer_inconnue = .fabrique_generateur_6e("INCONNUE_001", "algebre_6e")
generer_reg_suite = .fabrique_generateur_6e("REG_SUITE_001", "algebre_6e")
generer_per_rect = .fabrique_generateur_6e("PER_RECT_001", "mesures_6e")
generer_aire_rect = .fabrique_generateur_6e("AIRE_RECT_001", "mesures_6e")
generer_aire_conv = .fabrique_generateur_6e("AIRE_CONV_001", "mesures_6e")
generer_vol_pave = .fabrique_generateur_6e("VOL_PAVE_001", "mesures_6e")
generer_duree_conv = .fabrique_generateur_6e("DUREE_CONV_001", "mesures_6e")
generer_tri_angle = .fabrique_generateur_6e("TRI_ANGLE_001", "geometrie_6e")
generer_med_equidist = .fabrique_generateur_6e("MED_EQUIDIST_001", "geometrie_6e")
generer_cercle_diam = .fabrique_generateur_6e("CERCLE_DIAM_001", "geometrie_6e")
generer_sym_axe = .fabrique_generateur_6e("SYM_AXE_001", "geometrie_6e")
generer_data_filter = .fabrique_generateur_6e("DATA_FILTER_001", "donnees_6e")
generer_proba_simple = .fabrique_generateur_6e("PROBA_SIMPLE_001", "donnees_6e")
generer_freq_simple = .fabrique_generateur_6e("FREQ_SIMPLE_001", "donnees_6e")
generer_echelle = .fabrique_generateur_6e("ECHELLE_001", "donnees_6e")
generer_boucle = .fabrique_generateur_6e("BOUCLE_001", "algo_6e")
